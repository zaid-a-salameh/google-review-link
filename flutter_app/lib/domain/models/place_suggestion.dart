class PlaceSuggestion {
  const PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    this.secondaryText = '',
  });

  final String placeId;
  final String mainText;
  final String secondaryText;

  String get displayLabel =>
      secondaryText.isNotEmpty ? '$mainText - $secondaryText' : mainText;
}
