import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/models/nfc_models.dart';

class HardwareBridgeService {
  HardwareBridgeService();

  static const MethodChannel _methodChannel =
      MethodChannel('com.example.reviewlinkgenerator/hardware');
  static const EventChannel _eventChannel =
      EventChannel('com.example.reviewlinkgenerator/nfc_events');

  Stream<NfcHardwareEvent>? _nfcEventsStream;

  bool get _isAndroidNative =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Stream<NfcHardwareEvent> get nfcEvents {
    if (!_isAndroidNative) {
      return const Stream<NfcHardwareEvent>.empty();
    }
    return _nfcEventsStream ??= _eventChannel
        .receiveBroadcastStream()
        .map((dynamic raw) {
          if (raw is Map) {
            return NfcHardwareEvent.fromMap(raw);
          }
          return null;
        })
        .where((NfcHardwareEvent? e) => e != null)
        .cast<NfcHardwareEvent>();
  }

  Future<String> getNfcStatus() async {
    if (!_isAndroidNative) return 'NO_HARDWARE';
    try {
      final status = await _methodChannel.invokeMethod<String>('getNfcStatus');
      return status ?? 'NO_HARDWARE';
    } catch (_) {
      return 'NO_HARDWARE';
    }
  }

  Future<bool> isNetworkConnected() async {
    if (!_isAndroidNative) return true;
    try {
      final connected =
          await _methodChannel.invokeMethod<bool>('isNetworkConnected');
      return connected ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<String> getAppVersion() async {
    if (!_isAndroidNative) return '2.0.0';
    try {
      final ver = await _methodChannel.invokeMethod<String>('getAppVersion');
      return (ver != null && ver.trim().isNotEmpty) ? ver.trim() : '2.0.0';
    } catch (_) {
      return '2.0.0';
    }
  }

  Future<void> triggerLightHaptic() async {
    if (_isAndroidNative) {
      try {
        await _methodChannel.invokeMethod<void>('triggerLightHaptic');
        return;
      } catch (_) {}
    }
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  Future<void> triggerSuccessHaptic() async {
    if (_isAndroidNative) {
      try {
        await _methodChannel.invokeMethod<void>('triggerSuccessHaptic');
        return;
      } catch (_) {}
    }
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  Future<void> triggerErrorHaptic() async {
    if (_isAndroidNative) {
      try {
        await _methodChannel.invokeMethod<void>('triggerErrorHaptic');
        return;
      } catch (_) {}
    }
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  Future<bool> startNfcWrite(String url) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'startNfcWrite',
        <String, dynamic>{'url': url},
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcWifiWrite({
    required String ssid,
    required String password,
    required String encType,
  }) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'startNfcWifiWrite',
        <String, dynamic>{
          'ssid': ssid,
          'password': password,
          'encType': encType,
        },
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcRead() async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>('startNfcRead');
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcPermanentLock() async {
    if (!_isAndroidNative) return false;
    try {
      final ok =
          await _methodChannel.invokeMethod<bool>('startNfcPermanentLock');
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcErase() async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>('startNfcErase');
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcPasswordLock(String pin) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'startNfcPasswordLock',
        <String, dynamic>{'pin': pin},
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> startNfcPasswordUnlock(String pin) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'startNfcPasswordUnlock',
        <String, dynamic>{'pin': pin},
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> pauseNfcSession() async {
    if (!_isAndroidNative) return;
    try {
      await _methodChannel.invokeMethod<void>('pauseNfcSession');
    } catch (_) {}
  }

  Future<void> cancelNfcSession() async {
    if (!_isAndroidNative) return;
    try {
      await _methodChannel.invokeMethod<void>('cancelNfcSession');
    } catch (_) {}
  }

  Future<bool> saveQrImageBytes(Uint8List pngBytes, String filename) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'saveQrImage',
        <String, dynamic>{
          'bytes': pngBytes,
          'filename': filename,
        },
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> downloadAndInstallApk(String downloadUrl) async {
    if (!_isAndroidNative) return false;
    try {
      final ok = await _methodChannel.invokeMethod<bool>(
        'downloadAndInstallApk',
        <String, dynamic>{'url': downloadUrl},
      );
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }
}
