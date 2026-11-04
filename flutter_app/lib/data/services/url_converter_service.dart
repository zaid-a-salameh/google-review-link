import 'dart:convert';
import 'package:http/http.dart' as http;

class ShortUrlResolution {
  const ShortUrlResolution({
    this.resolvedText,
    this.noInternet = false,
  });

  final String? resolvedText;
  final bool noInternet;
}

class DirectUrlAnalysis {
  const DirectUrlAnalysis({
    required this.reviewUrl,
    this.locationUrl,
    this.placeId,
    this.isConvertedMapsPlace = false,
    this.errorType,
  });

  final String? reviewUrl;
  final String? locationUrl;
  final String? placeId;
  final bool isConvertedMapsPlace;
  final DirectUrlError? errorType;
}

enum DirectUrlError {
  empty,
  noInternet,
  invalidPlaceId,
}

class UrlConverterService {
  UrlConverterService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static String buildReviewUrl(String placeId) =>
      'https://search.google.com/local/writereview?placeid=${Uri.encodeComponent(placeId)}';

  static String buildLocationUrl(String placeId) =>
      'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${Uri.encodeComponent(placeId)}';

  static bool isMapsShortLink(String input) =>
      RegExp(r'maps\.app\.goo\.gl|goo\.gl\/maps', caseSensitive: false)
          .hasMatch(input);

  static bool isGoogleMapsUrl(String input) => RegExp(
        r'maps\.app\.goo\.gl|goo\.gl\/maps|google\.[a-z.]+\/maps',
        caseSensitive: false,
      ).hasMatch(input);

  static bool looksLikeUrlOrPlaceIdInSearch(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;
    return RegExp(r'https?:\/\/', caseSensitive: false).hasMatch(trimmed) ||
        RegExp(r'maps\.app\.goo\.gl', caseSensitive: false).hasMatch(trimmed) ||
        RegExp(r'goo\.gl\/maps', caseSensitive: false).hasMatch(trimmed) ||
        RegExp(r'placeid', caseSensitive: false).hasMatch(trimmed) ||
        trimmed.contains('ChIJ');
  }

  static String? hexToPlaceId(String featureId) {
    try {
      final parts = featureId.split(':');
      if (parts.length != 2) return null;

      final hexA = parts[0]
          .replaceFirst(RegExp(r'^0x', caseSensitive: false), '')
          .padLeft(16, '0');
      final hexB = parts[1]
          .replaceFirst(RegExp(r'^0x', caseSensitive: false), '')
          .padLeft(16, '0');

      if (hexA.length != 16 || hexB.length != 16) return null;

      List<int> toLittleEndian(String hex) {
        final bytes = <int>[];
        for (var i = hex.length - 2; i >= 0; i -= 2) {
          bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
        }
        return bytes;
      }

      final msg = <int>[
        0x0A,
        0x12,
        0x09,
        ...toLittleEndian(hexA),
        0x11,
        ...toLittleEndian(hexB),
      ];

      return base64UrlEncode(msg).replaceAll('=', '');
    } catch (_) {
      return null;
    }
  }

  static String? parsePlaceIdFromText(String? text) {
    if (text == null || text.trim().isEmpty) return null;

    String decoded;
    try {
      decoded = Uri.decodeFull(text);
    } catch (_) {
      decoded = text;
    }

    var match = RegExp(
      r'place_?id[=:]\s*([A-Za-z0-9_-]{15,})',
      caseSensitive: false,
    ).firstMatch(decoded);
    if (match != null) return match.group(1);

    match = RegExp(r'(ChIJ[A-Za-z0-9_-]{20,})').firstMatch(decoded);
    if (match != null) return match.group(1);

    match = RegExp(r'(?:!1s|ftid=)(0x[0-9a-fA-F]+:0x[0-9a-fA-F]+)')
        .firstMatch(decoded);
    if (match != null) {
      final pid = hexToPlaceId(match.group(1)!);
      if (pid != null) return pid;
    }

    match = RegExp(r'(0x[0-9a-fA-F]{10,}:0x[0-9a-fA-F]{10,})')
        .firstMatch(decoded);
    if (match != null) {
      final pid = hexToPlaceId(match.group(1)!);
      if (pid != null) return pid;
    }

    return null;
  }

  Future<ShortUrlResolution> resolveShortenedUrl(
    String shortUrl, {
    required bool isOnline,
  }) async {
    if (!isOnline) {
      return const ShortUrlResolution(noInternet: true);
    }

    final cleanUrl = shortUrl.trim();
    var networkError = false;

    // 1. Primary resolver: unshorten.me JSON endpoint
    try {
      final endpoint = Uri.parse(
        'https://unshorten.me/json/${Uri.encodeComponent(cleanUrl)}',
      );
      final res =
          await _httpClient.get(endpoint).timeout(const Duration(seconds: 6));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);
        if (data is Map && data['resolved_url'] is String) {
          final resolved = (data['resolved_url'] as String).trim();
          if (resolved.isNotEmpty) {
            return ShortUrlResolution(resolvedText: resolved);
          }
        }
      }
    } catch (_) {
      networkError = true;
    }

    // 2. Secondary fallback: direct HTTP follow-redirects & HTML inspection
    try {
      final directUri = Uri.parse(cleanUrl);
      final res =
          await _httpClient.get(directUri).timeout(const Duration(seconds: 6));
      final finalUrl = res.request?.url.toString();
      if (finalUrl != null &&
          finalUrl.isNotEmpty &&
          finalUrl != cleanUrl &&
          parsePlaceIdFromText(finalUrl) != null) {
        return ShortUrlResolution(resolvedText: finalUrl);
      }
      final hexMatch = RegExp(
        r'(0x[0-9a-fA-F]{10,}(?::|%3A)0x[0-9a-fA-F]{10,})',
        caseSensitive: false,
      ).firstMatch(res.body);
      if (hexMatch != null) {
        return ShortUrlResolution(
          resolvedText: Uri.decodeComponent(hexMatch.group(1)!),
        );
      }
    } catch (_) {
      networkError = true;
    }

    // 3. Tertiary fallback: allorigins raw HTML extraction
    try {
      final proxy = Uri.parse(
        'https://api.allorigins.win/raw?url=${Uri.encodeComponent(cleanUrl)}',
      );
      final res =
          await _httpClient.get(proxy).timeout(const Duration(seconds: 6));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final match = RegExp(
          r'(0x[0-9a-fA-F]{10,}(?::|%3A)0x[0-9a-fA-F]{10,})',
          caseSensitive: false,
        ).firstMatch(res.body);
        if (match != null) {
          return ShortUrlResolution(
            resolvedText: Uri.decodeComponent(match.group(1)!),
          );
        }
      }
    } catch (_) {
      networkError = true;
    }

    if (networkError) {
      return const ShortUrlResolution(noInternet: true);
    }

    return const ShortUrlResolution();
  }

  Future<DirectUrlAnalysis> analyzeAndConvert(
    String rawInput, {
    required bool isOnline,
    bool explicitConvertAction = false,
  }) async {
    final text = rawInput.trim();
    if (text.isEmpty) {
      return const DirectUrlAnalysis(
        reviewUrl: null,
        errorType: DirectUrlError.empty,
      );
    }

    // 1. Existing 5-star Google review link
    if (RegExp(r'writereview\?placeid=', caseSensitive: false).hasMatch(text)) {
      final pid = parsePlaceIdFromText(text);
      final locUrl = pid != null ? buildLocationUrl(pid) : null;
      return DirectUrlAnalysis(
        reviewUrl: text,
        locationUrl: locUrl,
        placeId: pid,
      );
    }

    // 2. Raw Google Maps share link or direct Place ID / feature ID
    final immediatePid = parsePlaceIdFromText(text);
    final isMaps = isGoogleMapsUrl(text);

    if (immediatePid != null) {
      final reviewUrl = buildReviewUrl(immediatePid);
      final locationUrl = isMaps ? text : buildLocationUrl(immediatePid);
      return DirectUrlAnalysis(
        reviewUrl: reviewUrl,
        locationUrl: locationUrl,
        placeId: immediatePid,
        isConvertedMapsPlace: true,
      );
    }

    if (isMaps) {
      if (isMapsShortLink(text)) {
        final resolution =
            await resolveShortenedUrl(text, isOnline: isOnline);
        if (resolution.noInternet) {
          return const DirectUrlAnalysis(
            reviewUrl: null,
            errorType: DirectUrlError.noInternet,
          );
        }
        final resolvedPid = parsePlaceIdFromText(resolution.resolvedText);
        if (resolvedPid != null) {
          return DirectUrlAnalysis(
            reviewUrl: buildReviewUrl(resolvedPid),
            locationUrl: text,
            placeId: resolvedPid,
            isConvertedMapsPlace: true,
          );
        }
      }

      return DirectUrlAnalysis(
        reviewUrl: null,
        errorType:
            isOnline ? DirectUrlError.invalidPlaceId : DirectUrlError.noInternet,
      );
    }

    // 3. Custom external URL (website, digital menu, social profile, etc.)
    if (RegExp(r'^https?:\/\/', caseSensitive: false).hasMatch(text) ||
        (!text.contains(' ') && text.contains('.'))) {
      final normalizedUrl =
          RegExp(r'^https?:\/\/', caseSensitive: false).hasMatch(text)
              ? text
              : 'https://$text';
      return DirectUrlAnalysis(
        reviewUrl: normalizedUrl,
      );
    }

    if (explicitConvertAction) {
      return DirectUrlAnalysis(
        reviewUrl: null,
        errorType:
            isOnline ? DirectUrlError.invalidPlaceId : DirectUrlError.noInternet,
      );
    }

    return const DirectUrlAnalysis(reviewUrl: null);
  }
}
