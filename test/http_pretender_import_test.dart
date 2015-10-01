@TestOn('browser')
library pretender.test.http_pretender_import_test;

import 'package:test/test.dart';
import 'package:web_components/web_components.dart';
import 'package:pretender/http_pretender.dart';

main() async {
  await initWebComponents();

  group('basic tests',(){
    test('imports javascript',(){
      var pretender = new HttpPretender();
      pretender.shutdown();
    });
  });

}