import 'dart:io';

import 'package:apk_parser/apk_parser.dart';

main() {
  // Read the Zip file from disk.
  List<int> bytes = new File(
      'example/app-debug.apk')
  .readAsBytesSync();

  parseManifest(bytes).listen((manifest) => print(manifest));
}