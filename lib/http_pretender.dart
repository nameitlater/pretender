// Copyright (c) 2015, the Name It Later Pretender authors (see AUTHORS file).
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library pretender.http_pretender;

import 'dart:js';

//TODO Should this be replaced with FakeXMLHttpRequest?
class Request {
  final String url;
  final String method;
  final Map<String,String> requestHeaders;
  final Map<String, String> params;
  final Map<String, String> queryParams;
  final String requestBody;

  Request(this.method, this.url, {params, requestHeaders, queryParams, requestBody}):
  this.params = params,
  this.requestHeaders = requestHeaders,
  this.queryParams = queryParams,
  this.requestBody = requestBody;

}


class Response {

  final int status;
  final Map<String, String> headers;
  final String responseText;

  Response(this.status, this.headers, this.responseText);

}

typedef Response RequestHandler(Request req);

typedef void RouteMapper(HttpPretender pretender);

typedef RequestErrorHandler (Request request, error);

typedef RequestHandledListener(Request, Response);

class HttpPretender {

  JsObject _pretender;

  HttpPretender([List<RouteMapper> maps= const []]): _pretender = new JsObject(context['Pretender']) {
    for(var m in maps){
      map(m);
    }
  }

  final Expando<int> handlerRequestCount = new Expando<int>();

  List<Request> get handledRequests {
    var dartRequests = [];
    for(var jsr in _pretender['handledRequests']){
      dartRequests.add(_jsRequestToDartRequest(jsr));
    }
    return dartRequests;
  }

  set erroredRequest (RequestErrorHandler handler){
    _pretender['erroredRequest'] = (method,route,request,error){
      handler(_jsRequestToDartRequest(request), error);
    };
  }

  set handledRequest (RequestHandledListener handler){
    _pretender['handledRequest'] = (verb, path, request){
      handler(_jsRequestToDartRequest(request), _jsRequestToDartResponse(request));
    };
  }

  void map(RouteMapper mapper){
    mapper(this);
  }

  void delete(String route, RequestHandler handler, {timing}){
    _register('delete', route, handler, timing);
  }

  void get(String route, RequestHandler handler, {dynamic timing}){
    _register('get', route, handler, timing);
  }

  void head(String route, RequestHandler handler, {dynamic timing}){
    _register('head', route, handler, timing);
  }

  void patch(String route, RequestHandler handler, {dynamic timing}){
    _register('patch', route, handler,  timing);
  }

  void post(String route, RequestHandler handler, {dynamic timing}){
    _register('post', route, handler, timing);
  }

  shutdown(){
    _pretender.callMethod('shutdown',[]);
  }

  _register(String method, String route, RequestHandler handler,  dynamic timing){
    if(handler != null) {
      this.handlerRequestCount[handler] = 0;
      _pretender.callMethod(method, [route, (jsr) {
        handlerRequestCount[handler] = handlerRequestCount[handler]+ 1;
        return _dartResponseToJs(handler(_jsRequestToDartRequest(jsr)));
      }, timing]);
    }else {
      _pretender.callMethod(method, [route]);
    }
  }

}



_dartResponseToJs(Response dr){
  if(dr != null) {
    return [dr.status, _dartHeadersToJsHeaders(dr.headers),
    dr.responseText];
  }else {
    return [];
  }
}

_jsRequestToDartRequest(JsObject jsr){
  return new Request(jsr['method'], jsr['url'],
      requestHeaders:_jsObjectToDartMap(jsr['requestHeaders']),
      params: _jsObjectToDartMap(jsr['params']),
      queryParams: _jsObjectToDartMap(jsr['queryParams']),
      requestBody: jsr['requestBody']);
}

    _jsRequestToDartResponse(JsObject jsr){
      return new Response(jsr['status'], _jsObjectToDartMap(jsr['responseHeaders']), jsr['responseText']);
    }

_dartHeadersToJsHeaders(Map<String, String> headers){
  return new JsObject.jsify(headers);
}

_jsObjectToDartMap(JsObject o){
  if(o == null){
    return null;
  }
  var map = new Map();
  Iterable<String> k = context['Object'].callMethod('keys', [o]);
  k.forEach((String k) {
    map[k] = o[k];
  });
  return map;
}

