
import 'dart:html';

import 'package:archive/archive.dart';



void download(Blob file, String name) {
String url = Url.createObjectUrlFromBlob(file);
// Create a link to navigate to that data and download it.
  AnchorElement link = new AnchorElement()
  ..href = url
  ..download = name
  ..text = 'Download Now!';



  var p = querySelector('#download_button');
  p.append(link);
  link.click();

}
