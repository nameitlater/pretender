@TestOn('browser')
library pretender.test.pretender_import_test;

import 'package:test/test.dart';
import 'package:web_components/web_components.dart';
import 'package:pretender/pretender.dart';

main() async {
  await initWebComponents();

  group('basic tests',(){
    test('imports javascript',(){
      var pretender = new Pretender();
      pretender.shutdown();
    });
  });

}