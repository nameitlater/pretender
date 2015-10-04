// Port of pretender calling_test.js


library pretender.test.http_pretender_calling_test;

import 'package:pretender/http_pretender.dart';
import 'package:test/test.dart';
import 'package:pretender/util.dart';

void main() {

  HttpPretender pretender;

  setUp((){
    pretender = new HttpPretender();
  });

  tearDown((){
    pretender.shutdown();
  });

  group('pretender invoking', ()
  {
    test('a mapping function is optional', () async {
      bool wasCalled;

      pretender.get('/some/path', (request) {
        wasCalled = true;
      });

      await ajax('/some/path');
      expect(wasCalled, isTrue);

    });


    test('mapping can be called directly', () async {
      var wasCalled;
      var map = (pretender) {
        pretender.get('/some/path', (request) {
          wasCalled = true;
        });

      };

      pretender.map(map);

      await ajax('/some/path');

      expect(wasCalled, isTrue);

    });


    test('params are passed', () async {
      var params;
      pretender.get('/some/path/:id', (request) {
        params = request.params;
      });

      await ajax('/some/path/1');
      expect(params['id'],'1');
    });

  });

  test('queryParams are passed', () async {
  var params;
  pretender.get('/some/path', (request) {
  params = request.queryParams;
  });

  await ajax('/some/path?zulu=nation');
  expect(params['zulu'], 'nation');
  });


  test('request body is accessible', () async {
  var params;
  pretender.post('/some/path/1', (request) {
  params = request.requestBody;
  });

  await ajax( '/some/path/1', method: 'post',
  data: {
  'ok': 'true'}
  );
  expect(params, 'ok=true');
  });

  test('request headers are accessible', () async {
  var headers;
  pretender.post('/some/path/1', (request) {
  headers = request.requestHeaders;
  });

  await ajax('/some/path/1',
  method: 'post',
  headers: {
  'A-Header': 'value'
  });
  expect(headers['A-Header'], equals('value'));
  });

  test('adds requests to the list of handled requests', () async {
  var params;
  pretender.get('/some/path', (request) {
  params = request.queryParams;
  });

  await ajax('/some/path');

  var req = pretender.handledRequests[0];
  expect(req.url, equals('/some/path'));
  });

  test('increments the handler\'s request count', () async {
  var handler = (req) {};

  pretender.get('/some/path', handler);

  await ajax('/some/path');

  expect(pretender.handlerRequestCount[handler], equals(1));
  });

  test('handledRequest is called',() async
  {

    var json = '{foo: "bar"}';
    pretender.get('/some/path', (req) {
    return new Response(200, {}, json);
    });

    pretender.handledRequest = (Request request, Response response) {
      expect(request.method, equals('GET'));
      expect(request.url, equals('/some/path'));
      expect(response.responseText, equals(json));
      expect(response.status, equals('200'));
    };

    await ajax( '/some/path');

  });

}

