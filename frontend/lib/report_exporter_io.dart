import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ReportExportResult {
  final bool success;
  final String message;

  const ReportExportResult({required this.success, required this.message});
}

const MethodChannel _androidExportChannel = MethodChannel(
  'tomodachi/report_exporter',
);

Future<Directory> _exportDirectory() async {
  if (Platform.isAndroid) {
    final downloads = Directory('/storage/emulated/0/Download');
    if (await downloads.exists()) {
      return downloads;
    }
  }

  return getApplicationDocumentsDirectory();
}

String _safeFileName(String value) {
  return value.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-');
}

Future<ReportExportResult> downloadReportFile({
  required String fileName,
  required String mimeType,
  required String content,
}) async {
  if (Platform.isAndroid) {
    try {
      final safeName = _safeFileName(fileName);
      final path = await _androidExportChannel.invokeMethod<String>(
        'saveToDownloads',
        {'fileName': safeName, 'mimeType': mimeType, 'content': content},
      );

      return ReportExportResult(
        success: true,
        message: 'File disimpan di ${path ?? 'folder Download'}',
      );
    } catch (e) {
      return ReportExportResult(
        success: false,
        message: 'Gagal menyimpan ke Download Android: $e',
      );
    }
  }

  try {
    final directory = await _exportDirectory();
    final safeName = _safeFileName(fileName);
    final file = File('${directory.path}${Platform.pathSeparator}$safeName');

    await file.writeAsBytes(utf8.encode(content), flush: true);

    return ReportExportResult(
      success: true,
      message: 'File disimpan di ${file.path}',
    );
  } catch (e) {
    return ReportExportResult(
      success: false,
      message: 'Gagal menyimpan file laporan: $e',
    );
  }
}

Future<ReportExportResult> openPrintableReport({
  required String title,
  required String htmlContent,
}) async {
  final stamp = DateTime.now()
      .toIso8601String()
      .substring(0, 16)
      .replaceAll(RegExp(r'[-:]'), '')
      .replaceAll('T', '-');

  if (Platform.isAndroid) {
    try {
      final safeTitle = _safeFileName(title.toLowerCase().replaceAll(' ', '-'));
      final fileName = '$safeTitle-$stamp.pdf';
      final path = await _androidExportChannel.invokeMethod<String>(
        'savePdfToDownloads',
        {'fileName': fileName, 'title': title, 'htmlContent': htmlContent},
      );

      return ReportExportResult(
        success: true,
        message: 'PDF disimpan di ${path ?? 'folder Download'}',
      );
    } catch (e) {
      return ReportExportResult(
        success: false,
        message: 'Gagal menyimpan PDF ke Download Android: $e',
      );
    }
  }

  return downloadReportFile(
    fileName:
        '${_safeFileName(title.toLowerCase().replaceAll(' ', '-'))}-$stamp.html',
    mimeType: 'text/html;charset=utf-8',
    content: htmlContent,
  );
}
