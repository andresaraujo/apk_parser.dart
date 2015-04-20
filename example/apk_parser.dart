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
