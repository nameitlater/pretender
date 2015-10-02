# pretender

Pretender is a Dart wrapper for [Pretender](https://github.com/pretenderjs/pretender),
a mock server library written in JavaScript.   It currently only supports a small
subset of the Pretender api (get, post, and map).

## Usage

### Usage in Basic HTML/Dart:
In your entrypoint HTML:
   ```
   <script src="packages/pretender/src/FakeXMLHttpRequest/fake_xml_http_request.js"></script>
   <script src="packages/pretender/src/route-recognizer/dist/route-recognizer.js"></script>
   <script src="packages/pretender/src/pretender/pretender.js"></script>
  ```

In your entrypoint Dart:
  ```
   import 'package:pretender/http_pretender.dart';

   main(){
    var somePath = (pretender) {
        pretender.get('/some/path', (request) {
            return new Response(200,
                {'content-type':'application/json'},
                    JSON.encode({'status':'ok'});
            });
        }

        var pretender = new HttpPretender();
        pretender.map(somePath);

    }

   ```

### Usage with Web Components:

In your entrypoint HTML:
 ```
<link rel="import" href="packages/pretender/http_pretender_import.html">

 ```

 In your entrypoint Dart:
 ```
 main() async {
   await initWebComponents();
   var pretender = new HttpPretender();
 }
 ```

## Limitations
This package currently breaks BrowserClient and HttpRequest both in Dartium and Javascript. See issue [24462](https://github.com/dart-lang/sdk/issues/24462). It's primarily useful for testing applications/web components built using [Polymer Elements](https://github.com/dart-lang/polymer_elements).

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/nameitlater/pretender
