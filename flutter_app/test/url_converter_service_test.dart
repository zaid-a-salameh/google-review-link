import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:review_link_generator/data/services/url_converter_service.dart';

void main() {
  group('UrlConverterService - Place ID & Hex Extraction', () {
    test('converts canonical Googleplex feature hex ID to exact ChIJ Place ID', () {
      const hexFeature = '0x808fba02425dad8f:0x6c296c66619367e0';
      final placeId = UrlConverterService.hexToPlaceId(hexFeature);
      expect(placeId, equals('ChIJj61dQgK6j4AR4GeTYWZsKWw'));
    });

    test('extracts Place ID from direct placeid query, ChIJ token, and !1s hex', () {
      expect(
        UrlConverterService.parsePlaceIdFromText(
          'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4',
        ),
        equals('ChIJN1t_tDeuEmsRUsoyG83frY4'),
      );

      expect(
        UrlConverterService.parsePlaceIdFromText(
          'https://www.google.com/maps/place/Googleplex/@37.422,-122.084,17z/data=!3m1!4b1!4m6!3m5!1s0x808fba02425dad8f:0x6c296c66619367e0!8m2',
        ),
        equals('ChIJj61dQgK6j4AR4GeTYWZsKWw'),
      );

      expect(
        UrlConverterService.parsePlaceIdFromText(
          'https://www.google.com/maps?ftid=0x808fba02425dad8f%3A0x6c296c66619367e0',
        ),
        equals('ChIJj61dQgK6j4AR4GeTYWZsKWw'),
      );
    });
  });

  group('UrlConverterService - analyzeAndConvert', () {
    test('converts full Google Maps URL into both 5-Star Review and Location URLs', () async {
      final service = UrlConverterService();
      const mapsUrl =
          'https://www.google.com/maps/place/Googleplex/data=!4m2!3m1!1s0x808fba02425dad8f:0x6c296c66619367e0';

      final result = await service.analyzeAndConvert(
        mapsUrl,
        isOnline: true,
        explicitConvertAction: true,
      );

      expect(result.errorType, isNull);
      expect(result.isConvertedMapsPlace, isTrue);
      expect(result.placeId, equals('ChIJj61dQgK6j4AR4GeTYWZsKWw'));
      expect(
        result.reviewUrl,
        equals(
          'https://search.google.com/local/writereview?placeid=ChIJj61dQgK6j4AR4GeTYWZsKWw',
        ),
      );
      expect(result.locationUrl, equals(mapsUrl));
    });

    test('resolves maps.app.goo.gl shortlink via HTTP client', () async {
      final mockClient = MockClient((http.Request request) async {
        if (request.url.host == 'unshorten.me') {
          return http.Response(
            jsonEncode(<String, dynamic>{
              'resolved_url':
                  'https://www.google.com/maps/place/?q=place_id:ChIJN1t_tDeuEmsRUsoyG83frY4',
            }),
            200,
          );
        }
        return http.Response('', 404);
      });

      final service = UrlConverterService(httpClient: mockClient);
      final result = await service.analyzeAndConvert(
        'https://maps.app.goo.gl/xyz987',
        isOnline: true,
        explicitConvertAction: true,
      );

      expect(result.errorType, isNull);
      expect(result.placeId, equals('ChIJN1t_tDeuEmsRUsoyG83frY4'));
      expect(
        result.reviewUrl,
        equals(
          'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4',
        ),
      );
      expect(result.locationUrl, equals('https://maps.app.goo.gl/xyz987'));
    });

    test('returns noInternet when resolving shortlink while offline', () async {
      final service = UrlConverterService();
      final result = await service.analyzeAndConvert(
        'https://maps.app.goo.gl/offline123',
        isOnline: false,
        explicitConvertAction: true,
      );

      expect(result.reviewUrl, isNull);
      expect(result.errorType, equals(DirectUrlError.noInternet));
    });

    test('normalizes custom external website URLs without Maps switcher', () async {
      final service = UrlConverterService();
      final result = await service.analyzeAndConvert(
        'menu.myrestaurant.com/order',
        isOnline: true,
        explicitConvertAction: true,
      );

      expect(result.errorType, isNull);
      expect(result.placeId, isNull);
      expect(result.locationUrl, isNull);
      expect(result.reviewUrl, equals('https://menu.myrestaurant.com/order'));
    });
  });
}
