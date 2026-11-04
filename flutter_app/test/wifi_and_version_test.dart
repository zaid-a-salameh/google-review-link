import 'package:flutter_test/flutter_test.dart';
import 'package:review_link_generator/domain/models/app_release_info.dart';
import 'package:review_link_generator/domain/models/nfc_models.dart';
import 'package:review_link_generator/domain/models/wifi_credentials.dart';

void main() {
  group('WifiCredentials - QR Payload & URI Parsing', () {
    test('formats WPA credentials and escapes special characters per ZXing spec', () {
      const creds = WifiCredentials(
        ssid: 'Cafe;Lobby:5G',
        password: r'p@ss\word,1"2',
        encryption: WifiEncryption.wpa,
      );

      final qr = creds.toWifiQrPayload();
      expect(
        qr,
        equals(r'WIFI:T:WPA;S:Cafe\;Lobby\:5G;P:p@ss\\word\,1\"2;;'),
      );

      final parsed = WifiCredentials.parseWifiUri(qr);
      expect(parsed, isNotNull);
      expect(parsed!.ssid, equals('Cafe;Lobby:5G'));
      expect(parsed.password, equals(r'p@ss\word,1"2'));
      expect(parsed.encryption, equals(WifiEncryption.wpa));
    });

    test('downgrades empty password to Open (nopass) network', () {
      const creds = WifiCredentials(
        ssid: 'GuestFreeWiFi',
        password: '',
        encryption: WifiEncryption.wpa,
      );

      expect(creds.effectiveEncryption, equals(WifiEncryption.open));
      expect(creds.toWifiQrPayload(), equals('WIFI:T:nopass;S:GuestFreeWiFi;P:;;'));
    });
  });

  group('AppReleaseInfo - Semantic Version Comparison & Byte Formatting', () {
    test('compares semantic versions with v prefixes and build metadata', () {
      expect(AppReleaseInfo.compareSemVer('v2.0.1', '2.0.0'), greaterThan(0));
      expect(AppReleaseInfo.compareSemVer('2.0.0+20', 'v2.0.0'), equals(0));
      expect(AppReleaseInfo.compareSemVer('1.2.1', 'v2.0.0'), lessThan(0));
      expect(AppReleaseInfo.compareSemVer('v2.1.0-beta', '2.0.0'), greaterThan(0));
    });

    test('formats APK byte sizes cleanly', () {
      expect(AppReleaseInfo.formatBytes(0), equals(''));
      expect(AppReleaseInfo.formatBytes(512), equals('512 B'));
      expect(AppReleaseInfo.formatBytes(204800), equals('200 KB'));
      expect(AppReleaseInfo.formatBytes(18 * 1024 * 1024), equals('18.0 MB'));
    });
  });

  group('NfcHardwareEvent - Native EventChannel Mapping', () {
    test('parses write_success, wifi_read, and error payloads accurately', () {
      final writeEvt = NfcHardwareEvent.fromMap(<String, dynamic>{
        'event': 'write_success',
        'count': 2,
        'op': 'WRITE_WIFI',
      });
      expect(writeEvt, isNotNull);
      expect(writeEvt!.type, equals(NfcHardwareEventType.writeSuccess));
      expect(writeEvt.count, equals(2));
      expect(writeEvt.operationCode, equals('WRITE_WIFI'));

      final wifiEvt = NfcHardwareEvent.fromMap(<String, dynamic>{
        'event': 'wifi_read',
        'ssid': 'OfficeNet',
        'password': 'secretpassword',
        'encType': 'WPA',
      });
      expect(wifiEvt, isNotNull);
      expect(wifiEvt!.type, equals(NfcHardwareEventType.wifiRead));
      expect(wifiEvt.wifiCredentials?.ssid, equals('OfficeNet'));
      expect(wifiEvt.wifiCredentials?.encryption, equals(WifiEncryption.wpa));

      final errEvt = NfcHardwareEvent.fromMap(<String, dynamic>{
        'event': 'error',
        'code': 'WRONG_PWD',
      });
      expect(errEvt, isNotNull);
      expect(errEvt!.type, equals(NfcHardwareEventType.error));
      expect(errEvt.errorCode, equals('WRONG_PWD'));
    });
  });
}
