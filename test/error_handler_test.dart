// Port of pretender error_test.js


library pretender.test.pretender_error_test;

import 'package:pretender/pretender.dart';
import 'package:test/test.dart';
import 'package:pretender/util.dart';

void main() {


  Pretender pretender;
  group('pretender errored requests', ()
  {

    setUp((){
      pretender = new Pretender();
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

