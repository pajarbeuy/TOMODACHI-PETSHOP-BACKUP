import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

web.Blob _textBlob(String content, String mimeType) {
  final bytes = Uint8List.fromList(utf8.encode(content));
  return web.Blob(
    <JSAny>[bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
}

bool downloadReportFile({
  required String fileName,
  required String mimeType,
  required String content,
}) {
  final blob = _textBlob(content, mimeType);
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;

  anchor
    ..href = url
    ..download = fileName;
  anchor.style.display = 'none';

  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return true;
}

bool openPrintableReport({required String title, required String htmlContent}) {
  final blob = _textBlob(htmlContent, 'text/html;charset=utf-8');
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  return true;
}
