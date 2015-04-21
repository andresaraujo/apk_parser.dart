library apk_parser.parser;

/**
 * Extract android manifest from apk files. Original implementation in Java can
 * be found here: http://pastebin.com/c53DuqMt
 */

const END_DOC_TAG = 0x00100101;
const START_TAG = 0x00100102;
const END_TAG = 0x00100103;
const TEXT_TAG = 0x00100104;

const INDENT_SPACES = "                                             ";

String parse(List<int> bytes) {
  StringBuffer xmlBuffer = new StringBuffer();
  xmlBuffer.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");

  // Compressed XML file/bytes starts with 24x bytes of data,
  // 9 32 bit words in little endian order (LSB first):
  // 0th word is 03 00 08 00
  // 3rd word SEEMS TO BE: Offset at then of StringTable
  // 4th word is: Number of strings in string table
  int numbStrings = lew(bytes, 4 * 4);

  // StringIndexTable starts at offset 24x, an array of 32 bit LE offsets
  // of the length/string data in the StringTable.
  int stringIndexTableOffset = 0x24;

  // StringTable, each string is represented with a 16 bit little endian
  // character count, followed by that number of 16 bit (LE) (Unicode)
  // chars.
  int stringTable = stringIndexTableOffset + numbStrings * 4;

  // XMLTags, The XML tag tree starts after some unknown content after the
  // StringTable. There is some unknown data after the StringTable, scan
  // forward from this point to the flag for the start of an XML start
  // tag. Start from the offset in the 3rd word.
  int xmlTagOffset = lew(bytes, 3 * 4);

  // Scan forward until we find the bytes: 0x02011000(x00100102 in normal
  // int)
  for (int offset = xmlTagOffset; offset < bytes.length - 4; offset += 4) {
    if (lew(bytes, offset) == START_TAG) {
      xmlTagOffset = offset;
      break;
    }
  }

  // XML tags and attributes:
  // Every XML start and end tag consists of 6 32 bit words:
  // 0th word: 02011000 for startTag and 03011000 for endTag
  // 1st word: a flag?, like 38000000
  // 2nd word: Line of where this tag appeared in the original source file
  // 3rd word: FFFFFFFF ??
  // 4th word: StringIndex of NameSpace name, or FFFFFFFF for default NS
  // 5th word: StringIndex of Element Name
  // (Note: 01011000 in 0th word means end of XML document, endDocTag)

  // Start tags (not end tags) contain 3 more words:
  // 6th word: 14001400 meaning??
  // 7th word: Number of Attributes that follow this tag(follow word 8th)
  // 8th word: 00000000 meaning??

  // Attributes consist of 5 words:
  // 0th word: StringIndex of Attribute Name's Namespace, or FFFFFFFF
  // 1st word: StringIndex of Attribute Name
  // 2nd word: StringIndex of Attribute Value, or FFFFFFF if ResourceId
  // used
  // 3rd word: Flags?
  // 4th word: str ind of attr value again, or ResourceId of value

  int off = xmlTagOffset;
  int indentCount = 0;
  int startTagLineNo = -2;

  // Step through the XML tree element tags and attributes
  while (off < bytes.length) {

    // Current tag
    int currentTag = lew(bytes, off);

    //Line number
    int lineNo = lew(bytes, off + 2 * 4);

    //Namespace index
    int nameNsSi = lew(bytes, off + 4 * 4);

    //String index
    int nameSi = lew(bytes, off + 5 * 4);

    switch (currentTag) {
      case START_TAG:
        // Expected to be 14001400
        int tagSix = lew(bytes, off + 6 * 4);

        // Number of Attributes to follow
        int numbAttrs = lew(bytes, off + 7 * 4);

        // Skip over 6+3 words of startTag data
        off += 9 * 4;

        // Tag name
        String tagName =
            compXmlString(bytes, stringIndexTableOffset, stringTable, nameSi);

        // Tag starts on line number
        startTagLineNo = lineNo;

        // Container for all characters
        StringBuffer attrString = new StringBuffer();

        // Parse all available attributes
        for (int i = 0; i < numbAttrs; i++) {

          // AttrName Namespace Str, Ind or FFFFFFFF
          int attrNameNsSi = lew(bytes, off);

          // AttrName String Index
          int attrNameSi = lew(bytes, off + 1 * 4);

          // AttrValue Str, Index or FFFFFFFF
          int attrValueSi = lew(bytes, off + 2 * 4);

          int attrFlags = lew(bytes, off + 3 * 4);

          // AttrValue ResourceId or dup AttrVale StrInd
          int attrResId = lew(bytes, off + 4 * 4);

          // Skip over 5 words of an attribute
          off += 5 * 4;

          // Name of attribute
          String attrName = compXmlString(
              bytes, stringIndexTableOffset, stringTable, attrNameSi);

          // Value of attribute
          String attrValue;

          if (attrValueSi != 0xffffffff) {
            attrValue = compXmlString(
                bytes, stringIndexTableOffset, stringTable, attrValueSi);
          } else {
            attrValue = "0x${attrResId.toRadixString(16).padLeft(8, "0")}";
          }

          attrString.write(" ${attrName}=\"${attrValue}\"");
        }

        // Push tag to XML buffer
        //appendXmlIndent(xmlBuffer, indentCount, "<${tagName + attrString.toString()}>");
        xmlBuffer.write("<${tagName + attrString.toString()}>");
        indentCount++;
        break;
      case END_TAG:
        indentCount--;

        // Skip over 6 words of endTag dag
        off += 6 * 4;

        // Grab the actual tag name
        String tagName =
            compXmlString(bytes, stringIndexTableOffset, stringTable, nameSi);

        // Push tag to XML buffer
        //appendXmlIndent(xmlBuffer, indentCount, "</${tagName}>");
        xmlBuffer.write("</${tagName}>");
        break;
      case END_DOC_TAG:
        return xmlBuffer.toString();
      default:
        throw new StateError(
            "Unrecognized tag code '${currentTag.toRadixString(16)}' at offset ${off}");
        break;
    }
  }
  return xmlBuffer.toString();
}

/**
 * Returns a string of the complete XML tag
 */
String compXmlString(List<int> bytes, int sitOff, int stOff, int strIndex) {
  if (strIndex < 0) return null;
  int strOff = stOff + lew(bytes, sitOff + strIndex * 4);
  return compXmlStringAt(bytes, strOff);
}

/**
 * Return the string stored in StringTable format at offset strOffset. This
 * offset points to the 16 bit string length, which is followed by that
 * number of 16 bit (Unicode) chars .
 */
String compXmlStringAt(List<int> bytes, int strOffset) {
  int strLen = bytes[strOffset + 1] << 8 & 0xff00 | bytes[strOffset] & 0xff;
  List<int> chars = new List(strLen);
  for (int i = 0; i < strLen; i++) {
    chars[i] = bytes[strOffset + 2 + i * 2];
  }
  return new String.fromCharCodes(chars);
}

/**
 * Return value of a Little Endian 32 bit word from the byte array at
 * a given offset.
 */
int lew(List<int> bytes, int offset) {
  return bytes[offset + 3] << 24 & 0xff000000 |
      bytes[offset + 2] << 16 & 0xff0000 |
      bytes[offset + 1] << 8 & 0xff00 |
      bytes[offset] & 0xFF;
}
