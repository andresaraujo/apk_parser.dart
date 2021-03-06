# apk_parser

A pure dart library for parsing android apk data

This is a work in progress

[![Pub](https://img.shields.io/pub/v/apk_parser.svg?style=flat-square)](https://pub.dartlang.org/packages/apk_parser)

## Usage

A simple usage example:

```dart
import 'dart:io';
import 'package:apk_parser/apk_parser.dart';

main() async {
  // Read the Zip file from disk.
  List<int> bytes = new File('example/app-debug.apk').readAsBytesSync();

  Manifest manifest = await parseManifest(bytes);

  print("""
    ==== Android Manifest Data ====
           Package : ${manifest.package}
      Version name : ${manifest.versionName}
      Version code : ${manifest.versionCode}
    """);

  print(" Activities");
  manifest.application.activities.forEach((act) => print("  - ${act.name}"));

  print("\n Xml");
  print(parseManifestXml(bytes));
}
```

## TODO
- Create a cli command
- Add documentation
- Better examples

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/andresaraujo/apk_parser.dart/issues
