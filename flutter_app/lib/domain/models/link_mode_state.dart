enum AppInputMode {
  link,
  search,
}

enum LinkOutputType {
  review,
  location,
}

class ModeResultState {
  const ModeResultState({
    this.reviewUrl,
    this.locationUrl,
    this.placeId,
    this.activeType = LinkOutputType.review,
    this.isResultActive = false,
  });

  const ModeResultState.empty()
      : reviewUrl = null,
        locationUrl = null,
        placeId = null,
        activeType = LinkOutputType.review,
        isResultActive = false;

  final String? reviewUrl;
  final String? locationUrl;
  final String? placeId;
  final LinkOutputType activeType;
  final bool isResultActive;

  bool get canSwitchLinkType =>
      isResultActive &&
      placeId != null &&
      placeId!.isNotEmpty &&
      locationUrl != null &&
      locationUrl!.isNotEmpty;

  String? get activeUrl {
    if (!isResultActive || reviewUrl == null || reviewUrl!.isEmpty) {
      return null;
    }
    if (canSwitchLinkType && activeType == LinkOutputType.location) {
      return locationUrl ?? reviewUrl;
    }
    return reviewUrl;
  }

  bool get isDirectReviewUrl {
    final url = activeUrl;
    if (url == null) return false;
    return RegExp(r'writereview\?placeid=', caseSensitive: false).hasMatch(url);
  }

  ModeResultState copyWith({
    String? reviewUrl,
    String? locationUrl,
    String? placeId,
    LinkOutputType? activeType,
    bool? isResultActive,
    bool clearUrls = false,
  }) {
    if (clearUrls) {
      return const ModeResultState.empty();
    }
    return ModeResultState(
      reviewUrl: reviewUrl ?? this.reviewUrl,
      locationUrl: locationUrl ?? this.locationUrl,
      placeId: placeId ?? this.placeId,
      activeType: activeType ?? this.activeType,
      isResultActive: isResultActive ?? this.isResultActive,
    );
  }
}
