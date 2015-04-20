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

/**
 * Return a [Manifest] object that represents the parsed AndroidManifest.xml
 */
Future<Manifest> parseManifest(List<int> bytes) {
  String xmlString = parseManifestXml(bytes);

  var xmlStreamer = new XmlStreamer(xmlString);

  var xmlObjectBuilder =
      new XmlObjectBuilder<Manifest>(xmlStreamer, new ManifestProcessor());

  return xmlObjectBuilder.onProcess().elementAt(0);
}

/**
 * Returns a string that represents the parsed AndroidManifest.xml
 */
String parseManifestXml(List<int> bytes) {

  // Decode the Zip file
  Archive archive = new ZipDecoder().decodeBytes(bytes);

  List<int> manifestBytes = archive.findFile('AndroidManifest.xml').content;

  return parser.parse(manifestBytes);
}
