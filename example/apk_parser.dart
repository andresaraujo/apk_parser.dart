import 'dart:io';

import 'package:apk_parser/apk_parser.dart';

main() {
  // Read the Zip file from disk.
  List<int> bytes = new File('example/app-debug.apk').readAsBytesSync();

  parseManifest(bytes).listen((manifest) {
    print("""
    ==== Android Manifest Data ====
          Package  : ${manifest.package}
      Version name : ${manifest.versionName}
      Version code : ${manifest.versionCode}
    """);

    print(" Activities");
    manifest.application.activities.forEach((act) => print("  - ${act.name}"));
  });
}
