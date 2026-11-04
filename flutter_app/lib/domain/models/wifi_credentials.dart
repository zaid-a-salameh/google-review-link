enum WifiEncryption {
  wpa,
  wep,
  open;

  String get protocolCode {
    switch (this) {
      case WifiEncryption.wpa:
        return 'WPA';
      case WifiEncryption.wep:
        return 'WEP';
      case WifiEncryption.open:
        return 'OPEN';
    }
  }

  String get qrAuthCode {
    switch (this) {
      case WifiEncryption.wpa:
        return 'WPA';
      case WifiEncryption.wep:
        return 'WEP';
      case WifiEncryption.open:
        return 'nopass';
    }
  }

  static WifiEncryption fromCode(String? raw) {
    final norm = (raw ?? 'WPA').trim().toUpperCase();
    if (norm == 'WEP') return WifiEncryption.wep;
    if (norm == 'OPEN' || norm == 'NONE' || norm == 'NOPASS') {
      return WifiEncryption.open;
    }
    return WifiEncryption.wpa;
  }
}

class WifiCredentials {
  const WifiCredentials({
    required this.ssid,
    this.password = '',
    this.encryption = WifiEncryption.wpa,
  });

  final String ssid;
  final String password;
  final WifiEncryption encryption;

  WifiEncryption get effectiveEncryption {
    if (encryption == WifiEncryption.open || password.isEmpty) {
      return WifiEncryption.open;
    }
    return encryption;
  }

  String get effectivePassword =>
      effectiveEncryption == WifiEncryption.open ? '' : password;

  static String escapeWifiValue(String input) {
    return input.replaceAllMapped(
      RegExp(r'([\\;,:"])'),
      (match) => '\\${match.group(1)}',
    );
  }

  String toWifiQrPayload() {
    final enc = effectiveEncryption;
    final escapedSsid = escapeWifiValue(ssid.trim());
    final escapedPass =
        enc == WifiEncryption.open ? '' : escapeWifiValue(effectivePassword);
    return 'WIFI:T:${enc.qrAuthCode};S:$escapedSsid;P:$escapedPass;;';
  }

  static WifiCredentials? parseWifiUri(String raw) {
    final trimmedRaw = raw.trim();
    if (trimmedRaw.isEmpty) return null;

    final content = trimmedRaw.toUpperCase().startsWith('WIFI:')
        ? trimmedRaw.substring(5)
        : trimmedRaw;

    String? ssid;
    String password = '';
    WifiEncryption? enc;

    final parts = _splitUnescapedSemicolons(content);
    for (final part in parts) {
      final t = part.trim();
      if (t.toUpperCase().startsWith('S:')) {
        ssid = _unescapeWifiValue(t.substring(2));
      } else if (t.toUpperCase().startsWith('P:')) {
        password = _unescapeWifiValue(t.substring(2));
      } else if (t.toUpperCase().startsWith('T:')) {
        enc = WifiEncryption.fromCode(t.substring(2));
      }
    }

    if (ssid == null || ssid.isEmpty) return null;
    final resolvedEnc =
        enc ?? (password.isNotEmpty ? WifiEncryption.wpa : WifiEncryption.open);
    return WifiCredentials(
      ssid: ssid,
      password: resolvedEnc == WifiEncryption.open ? '' : password,
      encryption: resolvedEnc,
    );
  }

  static List<String> _splitUnescapedSemicolons(String input) {
    final tokens = <String>[];
    final buf = StringBuffer();
    var escaped = false;
    for (var i = 0; i < input.length; i++) {
      final ch = input[i];
      if (escaped) {
        buf.write('\\');
        buf.write(ch);
        escaped = false;
      } else if (ch == '\\') {
        escaped = true;
      } else if (ch == ';') {
        tokens.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    if (escaped) buf.write('\\');
    tokens.add(buf.toString());
    return tokens;
  }

  static String _unescapeWifiValue(String val) {
    return val.replaceAllMapped(RegExp(r'\\(.)'), (m) => m.group(1) ?? '');
  }
}
