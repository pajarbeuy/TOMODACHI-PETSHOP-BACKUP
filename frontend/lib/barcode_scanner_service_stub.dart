import 'package:flutter/material.dart';

/// Non-web (Mobile / Desktop) fallback implementation for BarcodeScannerService.
/// This stub allows building Android APK and native binaries cleanly.
class BarcodeScannerService {
  bool get isScanning => false;

  void registerViewFactory(String elementId) {
    // No-op on mobile
  }

  Widget buildCameraPreview(String elementId) {
    return const Center(
      child: Text(
        'Kamera scanner hanya tersedia di Web browser.',
        style: TextStyle(color: Colors.white70, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> startCameraScanner({
    required String elementId,
    required void Function(String barcode) onScan,
    int fps = 10,
    int qrboxWidth = 250,
    int qrboxHeight = 250,
  }) async {
    throw UnsupportedError('Camera scanning is only supported on Web.');
  }

  Future<void> stopCameraScanner() async {}

  void playSuccessBeep() {}

  void playErrorBeep() {}

  void dispose() {}
}
