// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library apk_parser.test;

import 'dart:io';
import 'package:test/test.dart';
import 'package:apk_parser/apk_parser.dart';

main() async {
  List<int> bytes = new File('test/app-debug.apk').readAsBytesSync();

  group("parse to model", () {
    test("Should be valid model", () async {
      Manifest manifest = await parseManifest(bytes);
      expect(manifest, isNotNull);
      expect(manifest.package, equals("com.example.myapplication"));
      expect(manifest.versionCode, equals(1));
      expect(manifest.versionName, equals("1.0"));
      expect(manifest.application, isNotNull);
      expect(manifest.application.activities, hasLength(1));
      expect(manifest.usesSdk.minSdkVersion, equals(15));
      expect(manifest.usesSdk.targetSdkVersion, equals(21));
      expect(manifest.usesSdk.maxSdkVersion, isNull);
    });
  });

  group("parse to xml", () {
    test("should be a valid string", () {
      String xml = parseManifestXml(bytes);
      expect(xml, isNotNull);
      expect(xml, isNotEmpty);
    });
  });
}
