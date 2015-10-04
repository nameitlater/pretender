// Port of pretender creation_test.js


library pretender.test.http_pretender_creation_test;

import 'package:pretender/http_pretender.dart';
import 'package:test/test.dart';
import 'package:pretender/util.dart';

void main() {


  HttpPretender pretender;
  group('pretender creation', ()
  {

    tearDown(() {
      if (pretender != null) {
        pretender.shutdown();
      }

    });

    test('a mapping  is optional', () {
      var result = false;
      try {
        pretender = new HttpPretender();
        result = true;
      } catch (e) {

      }

      expect(result, isTrue);

    });

    test('many maps can be passed on creation', () async {
      var aWasCalled = false;
      var bWasCalled = false;

      var mapA = (pretender) {
        pretender.get('/some/path', (request) {
          aWasCalled = true;
        });
      };

      var mapB = (pretender) {
        pretender.get('/other/path', (request) {
          bWasCalled = true;
        });
      };

      pretender = new HttpPretender([mapA, mapB]);

      await ajax('/some/path');
      await ajax('/other/path');

      expect(aWasCalled, isTrue);
      expect(bWasCalled, isTrue);
    });

    test('an error is thrown when a request handler is missing', () {

      expect((){
        pretender = new HttpPretender();
        pretender.get('/path', null);
      }, throwsA(equals('Error: The function you tried passing to Pretender to handle GET /path is undefined or missing.')));

    });
  });

}

