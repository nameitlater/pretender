// Copyright (c) 2015, the Name It Later Pretender authors (see AUTHORS file).
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library pretender.http_pretender;

import 'dart:js';

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

class HttpPretender {

  JsObject _pretender;

  HttpPretender(): _pretender = new JsObject(context['Pretender'],[]);

  void map(RouteMapper mapper){
    mapper(this);
  }

  void get(String route, RequestHandler handler){
       _pretender.callMethod('get', [route,(jsr){
         return _dartResponseToJs(handler(_jsRequestToDart(jsr)));
       }]);
  }

  void post(String route, RequestHandler handler){
    _pretender.callMethod('post', [route,(jsr){
      return _dartResponseToJs(handler(_jsRequestToDart(jsr)));
    }]);
  }

  shutdown(){
    _pretender.callMethod('shutdown',[]);
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

_jsRequestToDart(JsObject jsr){
  var r = new Request(jsr['method'], jsr['url'],
      requestHeaders:_jsObjectToDartMap(jsr['requestHeaders']),
      params: _jsObjectToDartMap(jsr['params']),
      queryParams: _jsObjectToDartMap(jsr['queryParams']),
      requestBody: jsr['requestBody']);
  return r;
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