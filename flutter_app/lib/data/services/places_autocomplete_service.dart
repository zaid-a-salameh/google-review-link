import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../domain/models/place_suggestion.dart';

class PlacesAutocompleteResult {
  const PlacesAutocompleteResult({
    this.suggestions = const <PlaceSuggestion>[],
    this.rateLimited = false,
  });

  final List<PlaceSuggestion> suggestions;
  final bool rateLimited;
}

class PlacesAutocompleteService {
  PlacesAutocompleteService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _mapsApiKey = 'AIzaSyB-s2VuNM3Cqbli4YF5YIry7qfR_r34_UE';
  static const String _endpoint =
      'https://places.googleapis.com/v1/places:autocomplete';
  static const String _fieldMask =
      'suggestions.placePrediction.placeId,'
      'suggestions.placePrediction.structuredFormat.mainText.text,'
      'suggestions.placePrediction.structuredFormat.secondaryText.text,'
      'suggestions.placePrediction.text.text';
  static const int _hourlyLimit = 60;

  final http.Client _httpClient;
  final Map<String, List<PlaceSuggestion>> _cache =
      <String, List<PlaceSuggestion>>{};
  final Random _random = Random.secure();

  String? _sessionToken;
  int _hourlyCount = 0;
  DateTime _hourlyResetTime = DateTime.now().add(const Duration(hours: 1));

  String _ensureSessionToken() {
    return _sessionToken ??= _generateUuidV4();
  }

  void resetSessionToken() {
    _sessionToken = _generateUuidV4();
  }

  String _generateUuidV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40;
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    String hex(int start, int end) => bytes
        .sublist(start, end)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
  }

  bool _checkHourlyRateLimit() {
    final now = DateTime.now();
    if (now.isAfter(_hourlyResetTime)) {
      _hourlyCount = 0;
      _hourlyResetTime = now.add(const Duration(hours: 1));
    }
    if (_hourlyCount >= _hourlyLimit) {
      return false;
    }
    _hourlyCount++;
    return true;
  }

  Future<PlacesAutocompleteResult> fetchSuggestions(
    String query, {
    required String languageCode,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return const PlacesAutocompleteResult();
    }

    final cacheKey = '$languageCode:${trimmed.toLowerCase()}';
    final cached = _cache[cacheKey];
    if (cached != null) {
      return PlacesAutocompleteResult(suggestions: cached);
    }

    if (!_checkHourlyRateLimit()) {
      return const PlacesAutocompleteResult(rateLimited: true);
    }

    try {
      final response = await _httpClient
          .post(
            Uri.parse(_endpoint),
            headers: const <String, String>{
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': _mapsApiKey,
              'X-Goog-FieldMask': _fieldMask,
              'Referer': 'https://zaid-a-salameh.github.io/quick-nfc/',
              'Origin': 'https://zaid-a-salameh.github.io',
            },
            body: jsonEncode(<String, dynamic>{
              'input': trimmed,
              'languageCode': languageCode,
              'sessionToken': _ensureSessionToken(),
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const PlacesAutocompleteResult();
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const PlacesAutocompleteResult();
      }

      final rawSuggestions = decoded['suggestions'];
      if (rawSuggestions is! List) {
        _cache[cacheKey] = const <PlaceSuggestion>[];
        return const PlacesAutocompleteResult();
      }

      final parsed = <PlaceSuggestion>[];
      for (final item in rawSuggestions) {
        if (item is! Map) continue;
        final pred = item['placePrediction'];
        if (pred is! Map) continue;

        final placeId = (pred['placeId']?.toString() ?? '').trim();
        if (placeId.isEmpty) continue;

        String mainText = '';
        String secondaryText = '';

        final structured = pred['structuredFormat'];
        if (structured is Map) {
          final mainObj = structured['mainText'];
          if (mainObj is Map && mainObj['text'] != null) {
            mainText = mainObj['text'].toString().trim();
          }
          final secObj = structured['secondaryText'];
          if (secObj is Map && secObj['text'] != null) {
            secondaryText = secObj['text'].toString().trim();
          }
        }

        if (mainText.isEmpty) {
          final textObj = pred['text'];
          if (textObj is Map && textObj['text'] != null) {
            mainText = textObj['text'].toString().trim();
          }
        }

        if (mainText.isNotEmpty) {
          parsed.add(
            PlaceSuggestion(
              placeId: placeId,
              mainText: mainText,
              secondaryText: secondaryText,
            ),
          );
        }
      }

      _cache[cacheKey] = parsed;
      return PlacesAutocompleteResult(suggestions: parsed);
    } catch (_) {
      return const PlacesAutocompleteResult();
    }
  }
}
