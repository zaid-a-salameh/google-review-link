class AppReleaseInfo {
  const AppReleaseInfo({
    required this.tagVersion,
    required this.cleanVersion,
    required this.downloadUrl,
    required this.releasePageUrl,
    required this.releaseNotes,
    required this.assetSizeBytes,
    this.publishedAt,
  });

  final String tagVersion;
  final String cleanVersion;
  final String downloadUrl;
  final String releasePageUrl;
  final String releaseNotes;
  final int assetSizeBytes;
  final DateTime? publishedAt;

  static String normalizeVersion(String raw) {
    final trimmed = raw.trim().replaceFirst(RegExp(r'^[vV]'), '');
    final withoutBuild = trimmed.split('+').first;
    final withoutPreRelease = withoutBuild.split('-').first;
    return withoutPreRelease.trim();
  }

  static int compareSemVer(String a, String b) {
    final cleanA = normalizeVersion(a);
    final cleanB = normalizeVersion(b);
    final partsA = cleanA.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final partsB = cleanB.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final maxLen = partsA.length > partsB.length ? partsA.length : partsB.length;
    for (var i = 0; i < maxLen; i++) {
      final va = i < partsA.length ? partsA[i] : 0;
      final vb = i < partsB.length ? partsB[i] : 0;
      if (va > vb) return 1;
      if (va < vb) return -1;
    }
    return 0;
  }

  static String formatBytes(int bytes) {
    if (bytes <= 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
