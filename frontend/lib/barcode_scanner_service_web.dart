import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Web implementation for BarcodeScannerService using html5-qrcode and Web Audio API.

// ── JS Interop types ──────────────────────────────────────────────────────────

@JS('Html5Qrcode')
extension type _Html5Qrcode._(JSObject _) implements JSObject {
  external factory _Html5Qrcode(JSString elementId);

  external JSPromise<JSAny?> start(
    JSObject cameraIdOrConfig,
    JSObject config,
    JSFunction qrCodeSuccessCallback,
    JSFunction? qrCodeErrorCallback,
  );

  external JSPromise<JSAny?> stop();

  external JSPromise<JSAny?> clear();
}

@JS('AudioContext')
extension type _AudioContext._(JSObject _) implements JSObject {
  external factory _AudioContext();

  external _AudioDestinationNode get destination;
  external double get currentTime;
  external _OscillatorNode createOscillator();
  external _GainNode createGain();
}

@JS()
extension type _AudioDestinationNode._(JSObject _) implements JSObject {}

@JS()
extension type _OscillatorNode._(JSObject _) implements JSObject {
  external _AudioParam get frequency;
  external set type(JSString value);
  external void connect(JSObject destination);
  external void start([double when]);
  external void stop([double when]);
}

@JS()
extension type _GainNode._(JSObject _) implements JSObject {
  external _AudioParam get gain;
  external void connect(JSObject destination);
}

@JS()
extension type _AudioParam._(JSObject _) implements JSObject {
  external set value(double v);
  external void setValueAtTime(double value, double time);
  external void exponentialRampToValueAtTime(double value, double time);
}

// ── Barcode Scanner Service (Web) ─────────────────────────────────────────────

class BarcodeScannerService {
  _Html5Qrcode? _scanner;
  bool _isScanning = false;
  _AudioContext? _audioCtx;

  bool get isScanning => _isScanning;

  /// Register HTML view factory so HtmlElementView can be rendered in DOM
  void registerViewFactory(String elementId) {
    ui_web.platformViewRegistry.registerViewFactory(
      elementId,
      (int viewId) {
        final div = web.document.createElement('div') as web.HTMLDivElement;
        div.id = elementId;
        div.style.width = '100%';
        div.style.height = '100%';
        return div;
      },
    );
  }

  /// Build camera preview widget for web
  Widget buildCameraPreview(String elementId) {
    return HtmlElementView(viewType: elementId);
  }

  /// Start camera scanner in the given HTML element ID.
  Future<void> startCameraScanner({
    required String elementId,
    required void Function(String barcode) onScan,
    int fps = 10,
    int qrboxWidth = 250,
    int qrboxHeight = 250,
  }) async {
    if (_isScanning) return;

    try {
      _scanner = _Html5Qrcode(elementId.toJS);

      final config = {
        'fps': fps,
        'qrbox': {'width': qrboxWidth, 'height': qrboxHeight},
      }.jsify() as JSObject;

      final facingMode = {'facingMode': 'environment'}.jsify() as JSObject;

      bool isPaused = false;

      final successCallback = (JSString decodedText, JSAny? decodedResult) {
        if (isPaused) return;
        final barcode = decodedText.toDart.trim();
        if (barcode.isNotEmpty) {
          isPaused = true;
          onScan(barcode);
          Future<void>.delayed(const Duration(seconds: 1), () {
            isPaused = false;
          });
        }
      }.toJS;

      final errorCallback = (JSString errorMessage, JSAny? error) {
        // Silently ignore frame read errors
      }.toJS;

      await _scanner!
          .start(facingMode, config, successCallback, errorCallback)
          .toDart;
      _isScanning = true;
    } catch (e) {
      _isScanning = false;
      rethrow;
    }
  }

  /// Stop the camera scanner and clean up.
  Future<void> stopCameraScanner() async {
    if (!_isScanning || _scanner == null) return;
    try {
      await _scanner!.stop().toDart;
      await _scanner!.clear().toDart;
    } catch (_) {
      // Best-effort cleanup
    } finally {
      _isScanning = false;
      _scanner = null;
    }
  }

  // ── Audio Feedback (Web Audio API) ────────────────────────────────────────

  _AudioContext _getAudioContext() {
    _audioCtx ??= _AudioContext();
    return _audioCtx!;
  }

  /// Play a short success beep (high frequency, 150ms)
  void playSuccessBeep() {
    try {
      final ctx = _getAudioContext();
      final oscillator = ctx.createOscillator();
      final gainNode = ctx.createGain();

      oscillator.type = 'sine'.toJS;
      oscillator.frequency.value = 1200;
      gainNode.gain.setValueAtTime(0.3, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.15);

      oscillator.connect(gainNode as JSObject);
      gainNode.connect(ctx.destination as JSObject);

      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.15);
    } catch (_) {}
  }

  /// Play a short error beep (low frequency, 300ms)
  void playErrorBeep() {
    try {
      final ctx = _getAudioContext();
      final oscillator = ctx.createOscillator();
      final gainNode = ctx.createGain();

      oscillator.type = 'square'.toJS;
      oscillator.frequency.value = 300;
      gainNode.gain.setValueAtTime(0.2, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.3);

      oscillator.connect(gainNode as JSObject);
      gainNode.connect(ctx.destination as JSObject);

      oscillator.start(ctx.currentTime);
      oscillator.stop(ctx.currentTime + 0.3);
    } catch (_) {}
  }

  void dispose() {
    stopCameraScanner();
    _audioCtx = null;
  }
}
