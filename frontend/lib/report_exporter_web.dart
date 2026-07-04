import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

class ReportExportResult {
  final bool success;
  final String message;

  const ReportExportResult({required this.success, required this.message});
}

web.Blob _textBlob(String content, String mimeType) {
  final bytes = Uint8List.fromList(utf8.encode(content));
  return web.Blob(
    <JSAny>[bytes.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
}

Future<ReportExportResult> downloadReportFile({
  required String fileName,
  required String mimeType,
  required String content,
}) async {
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
  return ReportExportResult(
    success: true,
    message: 'File $fileName berhasil dibuat.',
  );
}

Future<ReportExportResult> openPrintableReport({
  required String title,
  required String htmlContent,
}) async {
  final blob = _textBlob(htmlContent, 'text/html;charset=utf-8');
  final url = web.URL.createObjectURL(blob);
  web.window.open(url, '_blank');
  return const ReportExportResult(
    success: true,
    message: 'Laporan PDF dibuka. Pilih "Save as PDF" di dialog print.',
  );
}
