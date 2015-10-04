// Port of pretender error_test.js


library pretender.test.http_pretender_error_test;

import 'package:pretender/http_pretender.dart';
import 'package:test/test.dart';
import 'package:pretender/util.dart';

void main() {


  HttpPretender pretender;
  group('pretender errored requests', ()
  {

    setUp((){
      pretender = new HttpPretender();
    });

    tearDown(() {
      if (pretender != null) {
        pretender.shutdown();
      }

    });

    test('calls erroredRequest', () {
    pretender.get('/some/path', (request) {
      throw 'something in this handler broke!';
    });

    pretender.erroredRequest = (request, error) {
      expect(error,isNotNull);
    };

    ajax( '/some/path');
    });
  });

}

