import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/models/app_release_info.dart';

class GithubUpdaterService {
  GithubUpdaterService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _latestReleaseEndpoint =
      'https://api.github.com/repos/zaid-a-salameh/quick-nfc/releases/latest';

  final http.Client _httpClient;

  Future<AppReleaseInfo?> checkForNewerRelease(String currentVersion) async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse(_latestReleaseEndpoint),
            headers: const <String, String>{
              'Accept': 'application/vnd.github+json',
            },
          )
          .timeout(const Duration(milliseconds: 3500));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;

      final tagName = (data['tag_name']?.toString() ?? '').trim();
      if (tagName.isEmpty) return null;

      final cleanRemote = AppReleaseInfo.normalizeVersion(tagName);
      if (AppReleaseInfo.compareSemVer(cleanRemote, currentVersion) <= 0) {
        return null;
      }

      String? apkDownloadUrl;
      var apkSize = 0;

      final assets = data['assets'];
      if (assets is List) {
        for (final asset in assets) {
          if (asset is! Map) continue;
          final name = (asset['name']?.toString() ?? '').toLowerCase();
          final url = (asset['browser_download_url']?.toString() ?? '').trim();
          if (name.endsWith('.apk') && url.isNotEmpty) {
            apkDownloadUrl = url;
            final rawSize = asset['size'];
            apkSize = rawSize is int
                ? rawSize
                : int.tryParse(rawSize?.toString() ?? '') ?? 0;
            break;
          }
        }
      }

      if (apkDownloadUrl == null || apkDownloadUrl.isEmpty) {
        return null;
      }

      final htmlUrl = (data['html_url']?.toString() ??
              'https://github.com/zaid-a-salameh/quick-nfc/releases')
          .trim();
      final body = (data['body']?.toString() ?? '').trim();
      final publishedRaw = data['published_at']?.toString();
      final publishedAt =
          publishedRaw != null ? DateTime.tryParse(publishedRaw) : null;

      return AppReleaseInfo(
        tagVersion: tagName,
        cleanVersion: cleanRemote,
        downloadUrl: apkDownloadUrl,
        releasePageUrl: htmlUrl,
        releaseNotes: body,
        assetSizeBytes: apkSize,
        publishedAt: publishedAt,
      );
    } catch (_) {
      return null;
    }
  }
}
