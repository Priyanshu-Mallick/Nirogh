import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

Widget getFilePreviewWidget(String filePath) {
  if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
    // Display image file
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.file(File(filePath)),
    );
  } else if (filePath.endsWith('.pdf')) {
    // Display PDF file using flutter_pdfview package
    return PDFView(
      filePath: filePath,
      autoSpacing: false, // This ensures the height is adjusted to content size
    );
  } else if (filePath.endsWith('.txt')) {
    // Display text document
    String fileContent = File(filePath).readAsStringSync();
    return Text(fileContent);
  } else {
    // Handle other file types or provide an error message
    return Text('Unsupported file type');
  }
}
