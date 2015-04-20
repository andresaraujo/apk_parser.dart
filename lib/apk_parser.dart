// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The apk_parser library.
///
library apk_parser;

import 'package:archive/archive.dart';
import 'package:xmlstream/xmlstream.dart';
import 'package:apk_parser/src/parser.dart' as parser;
import 'package:apk_parser/src/models.dart';
import 'package:apk_parser/src/processors.dart';
import 'dart:async';

export 'src/models.dart';

Stream<Manifest> parseManifest(List<int> bytes) {

  // Decode the Zip file
  Archive archive = new ZipDecoder().decodeBytes(bytes);

  List<int> manifestBytes = archive.findFile('AndroidManifest.xml').content;

  String xmlString = parser.parse(manifestBytes);

  var xmlStreamer = new XmlStreamer(xmlString);

  var xmlObjectBuilder =
      new XmlObjectBuilder<Manifest>(xmlStreamer, new ManifestProcessor());

  //xmlObjectBuilder.onProcess().listen((e) => print("listen: ${e.application}"));
  return xmlObjectBuilder.onProcess();
}
