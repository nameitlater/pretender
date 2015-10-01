library util.dart;

import 'dart:js';
import 'dart:async';

Future<JsObject> ajax(String url, {String method: 'GET', Map<String, String> data, Map<String, String> headers}) async {
  var client = new JsObject(context["XMLHttpRequest"], []);

  var completer = new Completer();

  client.callMethod('addEventListener', ['load',(e){
    completer.complete(e);
  }]);
  client.callMethod('addEventListener', ['error',(e){
    completer.completeError(e);
  }]);

  switch(method.toUpperCase()){
    case 'POST':
      client.callMethod('open',['POST', url]);
      _addHeaders(headers, client);
      if(data != null){
        client.callMethod('send',[_encodeBody(data)]);
      }else {
        client.callMethod('send', []);
      }
      break;
    case 'GET':
      if(data != null){
        client.callMethod('open', ['GET', new Uri(path: url, queryParameters:data).toString()]);
        _addHeaders(headers, client);
      }else {
        client.callMethod('open', ['GET', url]);
        _addHeaders(headers, client);
      }
      client.callMethod('send',[]);
      break;
    default:
      throw ArgumentError('Unknown method ${method}');
  }





  await completer.future;

  return new Future.value(client);

}

_addHeaders(Map<String, String> headers, JsObject client){
  if(headers != null){
    for(var header in headers.keys){
      client.callMethod('setRequestHeader', [header, headers[header]]);
    }
  }
}

_encodeBody(Map<String, String> body){
  var buffer = new StringBuffer();
  for(var k in body.keys){
    buffer.write('$k=${body[k]}&');
  }
  return buffer.toString().substring(0, buffer.length-1);
}

