# apk_parser

A pure dart library for parsing android apk data

This is a work in progress

## Usage

A simple usage example:

```dart
import 'dart:io';
import 'package:apk_parser/apk_parser.dart';

main() {
  // Read the Zip file from disk.
  List<int> bytes = new File('example/app-debug.apk').readAsBytesSync();

  parseManifest(bytes).listen((manifest) => print(manifest));
}
```

## TODO
- Add tests
- Create a cli command
- Add documentation
- Better examples

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/andresaraujo/apk_parser.dart/issues
