import 'wifi_credentials.dart';

enum NfcSubView {
  sensor,
  pin,
  permConfirm,
  eraseConfirm,
  wifiWizard,
}

enum NfcOperation {
  writeUrl,
  writeWifi,
  read,
  permLock,
  pwdLock,
  pwdUnlock,
  erase,
}

enum NfcSensorState {
  ready,
  readReady,
  permLockReady,
  permLockStandby,
  pwdLockReady,
  pwdUnlockReady,
  wifiReady,
  eraseReady,
  eraseStandby,
  success,
  error,
}

enum NfcVisualTheme {
  link,
  lock,
  unlock,
  permLock,
  wifi,
}

enum PinMode {
  lock,
  unlock,
}

enum NfcHardwareEventType {
  writeSuccess,
  eraseSuccess,
  wifiRead,
  urlRead,
  permLockSuccess,
  pwdSuccess,
  error,
  sessionPaused,
}

class NfcHardwareEvent {
  const NfcHardwareEvent({
    required this.type,
    this.count = 0,
    this.operationCode,
    this.url,
    this.wifiCredentials,
    this.pwdAction,
    this.errorCode,
  });

  final NfcHardwareEventType type;
  final int count;
  final String? operationCode;
  final String? url;
  final WifiCredentials? wifiCredentials;
  final String? pwdAction;
  final String? errorCode;

  static NfcHardwareEvent? fromMap(Map<dynamic, dynamic> map) {
    final event = map['event']?.toString();
    switch (event) {
      case 'write_success':
        final rawCount = map['count'];
        final parsedCount = rawCount is int
            ? rawCount
            : int.tryParse(rawCount?.toString() ?? '') ?? 1;
        return NfcHardwareEvent(
          type: NfcHardwareEventType.writeSuccess,
          count: parsedCount,
          operationCode: map['op']?.toString(),
        );
      case 'erase_success':
        final rawCount = map['count'];
        final parsedCount = rawCount is int
            ? rawCount
            : int.tryParse(rawCount?.toString() ?? '') ?? 1;
        return NfcHardwareEvent(
          type: NfcHardwareEventType.eraseSuccess,
          count: parsedCount,
          operationCode: map['op']?.toString() ?? 'ERASE',
        );
      case 'wifi_read':
        final ssid = (map['ssid']?.toString() ?? '').trim();
        if (ssid.isEmpty) return null;
        final pass = map['password']?.toString() ?? '';
        final enc = WifiEncryption.fromCode(map['encType']?.toString());
        return NfcHardwareEvent(
          type: NfcHardwareEventType.wifiRead,
          wifiCredentials: WifiCredentials(
            ssid: ssid,
            password: enc == WifiEncryption.open ? '' : pass,
            encryption: enc,
          ),
        );
      case 'url_read':
        final url = (map['url']?.toString() ?? '').trim();
        if (url.isEmpty) return null;
        return NfcHardwareEvent(
          type: NfcHardwareEventType.urlRead,
          url: url,
        );
      case 'perm_lock_success':
        return const NfcHardwareEvent(type: NfcHardwareEventType.permLockSuccess);
      case 'pwd_success':
        return NfcHardwareEvent(
          type: NfcHardwareEventType.pwdSuccess,
          pwdAction: map['action']?.toString() ?? 'UNLOCKED',
        );
      case 'error':
        return NfcHardwareEvent(
          type: NfcHardwareEventType.error,
          errorCode: map['code']?.toString() ?? 'WRITE_FAILED',
        );
      case 'session_paused':
        return const NfcHardwareEvent(type: NfcHardwareEventType.sessionPaused);
      default:
        return null;
    }
  }
}
