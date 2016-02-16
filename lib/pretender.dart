
import 'package:js/js.dart';
import "package:func/func.dart";

@JS()
@anonymous
class Request {

  external String get url;
  external String get method;
  external Map<String, String> get requestHeaders;
  external Map<String, String> get params;
  external Map<String, String> get queryParams;
  external String get requestBody;
  
}

typedef void RouteMapper(Pretender pretender);

@JS('Pretender')
class Pretender {
  external factory Pretender();
  external map(VoidFunc1<Pretender> mapper);
  external get(String path, Func1<Request, List> handler);
  external post(String path, Func1<Request, List> handler);
}