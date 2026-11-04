import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/services/github_updater_service.dart';
import '../../../../data/services/hardware_bridge_service.dart';
import '../../../../data/services/places_autocomplete_service.dart';
import '../../../../data/services/preferences_service.dart';
import '../../../../data/services/url_converter_service.dart';
import '../../../../domain/models/app_release_info.dart';
import '../../../../domain/models/link_mode_state.dart';
import '../../../../domain/models/place_suggestion.dart';
import '../../../../domain/models/toast_message.dart';
import '../../../../l10n/app_localizations.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required PreferencesService preferencesService,
    UrlConverterService? urlConverterService,
    PlacesAutocompleteService? placesService,
    HardwareBridgeService? hardwareBridge,
    GithubUpdaterService? updaterService,
  })  : _preferencesService = preferencesService,
        _urlConverterService = urlConverterService ?? UrlConverterService(),
        _placesService = placesService ?? PlacesAutocompleteService(),
        _hardwareBridge = hardwareBridge ?? HardwareBridgeService(),
        _updaterService = updaterService ?? GithubUpdaterService(),
        _selectedLanguageCode = preferencesService.getSavedLanguageCode(),
        _selectedThemeMode = preferencesService.getSavedThemeMode(),
        _locale = Locale(preferencesService.getSavedLanguageCode());

  final PreferencesService _preferencesService;
  final UrlConverterService _urlConverterService;
  final PlacesAutocompleteService _placesService;
  final HardwareBridgeService _hardwareBridge;
  final GithubUpdaterService _updaterService;

  HardwareBridgeService get hardwareBridge => _hardwareBridge;

  final TextEditingController urlController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<ToastMessage?> toastNotifier =
      ValueNotifier<ToastMessage?>(null);

  String _selectedLanguageCode;
  String get selectedLanguageCode => _selectedLanguageCode;

  String _selectedThemeMode;
  String get selectedThemeMode => _selectedThemeMode;

  ThemeMode get themeMode {
    switch (_selectedThemeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Locale _locale;
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  AppInputMode _activeMode = AppInputMode.link;
  AppInputMode get activeMode => _activeMode;

  ModeResultState _linkResult = const ModeResultState.empty();
  ModeResultState _searchResult = const ModeResultState.empty();

  ModeResultState get currentResult =>
      _activeMode == AppInputMode.link ? _linkResult : _searchResult;

  String? get activeGeneratedUrl => currentResult.activeUrl;

  bool _isResolvingLink = false;
  bool get isResolvingLink => _isResolvingLink;

  bool _isCopiedFeedback = false;
  bool get isCopiedFeedback => _isCopiedFeedback;

  bool _isSearchingPlaces = false;
  bool get isSearchingPlaces => _isSearchingPlaces;

  bool _isDropdownOpen = false;
  bool get isDropdownOpen => _isDropdownOpen;

  List<PlaceSuggestion> _placeSuggestions = const <PlaceSuggestion>[];
  List<PlaceSuggestion> get placeSuggestions => _placeSuggestions;

  String _currentAppVersion = '2.0.0';
  String get currentAppVersion => _currentAppVersion;

  AppReleaseInfo? _availableUpdate;
  AppReleaseInfo? get availableUpdate => _availableUpdate;
  @visibleForTesting
  set availableUpdate(AppReleaseInfo? val) {
    _availableUpdate = val;
    notifyListeners();
  }

  bool _isCheckingUpdate = false;
  bool get isCheckingUpdate => _isCheckingUpdate;

  int _toastCounter = 0;
  Timer? _toastTimer;
  Timer? _directInputDebounce;
  Timer? _searchDebounce;
  Timer? _copiedResetTimer;

  bool get shouldAutoShowOnboarding =>
      !_preferencesService.isOnboardingCompleted;

  Future<void> markOnboardingSeen() async {
    await _preferencesService.markOnboardingCompleted();
  }

  Future<void> initializeStartupChecks({bool checkUpdates = true}) async {
    _currentAppVersion = await _hardwareBridge.getAppVersion();
    if (!checkUpdates) return;
    final release =
        await _updaterService.checkForNewerRelease(_currentAppVersion);
    if (release != null) {
      _availableUpdate = release;
      notifyListeners();
    }
  }

  void dismissAvailableUpdate() {
    if (_availableUpdate != null) {
      _availableUpdate = null;
      notifyListeners();
    }
  }

  Future<AppReleaseInfo?> checkForUpdatesManual(AppLocalizations l10n) async {
    if (_availableUpdate != null) {
      return _availableUpdate;
    }
    if (_isCheckingUpdate) return null;

    _isCheckingUpdate = true;
    notifyListeners();
    showToast(l10n.toastCheckingUpdate, type: ToastType.info);

    try {
      if (_currentAppVersion.isEmpty) {
        _currentAppVersion = await _hardwareBridge.getAppVersion();
      }
      final release =
          await _updaterService.checkForNewerRelease(_currentAppVersion);
      _isCheckingUpdate = false;

      // Ensure the first message stays visible comfortably, then retracts before showing the second
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      hideToast();
      await Future<void>.delayed(const Duration(milliseconds: 320));

      if (release != null) {
        _availableUpdate = release;
        notifyListeners();
        showToast(
          l10n.toastUpdateFound(release.tagVersion),
          type: ToastType.success,
        );
        return release;
      } else {
        notifyListeners();
        showToast(
          l10n.toastUpToDate(_currentAppVersion),
          type: ToastType.success,
        );
        return null;
      }
    } catch (_) {
      _isCheckingUpdate = false;
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      hideToast();
      await Future<void>.delayed(const Duration(milliseconds: 320));
      notifyListeners();
      showToast(l10n.toastUpdateError, type: ToastType.error);
      return null;
    }
  }

  Future<void> startUpdateDownload(AppLocalizations l10n) async {
    final release = _availableUpdate;
    if (release == null) return;
    showToast(l10n.toastDownloadStarted, type: ToastType.info);
    final ok = await _hardwareBridge.downloadAndInstallApk(release.downloadUrl);
    if (!ok) {
      final uri = Uri.tryParse(release.downloadUrl);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void hideToast() {
    _toastTimer?.cancel();
    toastNotifier.value = null;
  }

  void showToast(String message, {ToastType type = ToastType.info}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    _toastTimer?.cancel();
    _toastCounter++;
    toastNotifier.value = ToastMessage(
      id: _toastCounter,
      message: trimmed,
      type: type,
    );
    _toastTimer = Timer(const Duration(milliseconds: 2600), () {
      toastNotifier.value = null;
    });
  }

  Future<void> switchLanguage(String langCode) async {
    final validCode = PreferencesService.supportedLanguages.contains(langCode)
        ? langCode
        : 'en';
    if (_selectedLanguageCode == validCode) return;
    _selectedLanguageCode = validCode;
    _locale = Locale(validCode);
    await _preferencesService.setLanguageCode(validCode);
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  Future<void> switchThemeMode(String mode) async {
    final validMode = PreferencesService.supportedThemeModes.contains(mode)
        ? mode
        : 'system';
    if (_selectedThemeMode == validMode) return;
    _selectedThemeMode = validMode;
    await _preferencesService.setThemeMode(validMode);
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  void switchMode(AppInputMode mode) {
    if (_activeMode == mode) return;
    _activeMode = mode;
    if (mode == AppInputMode.link) {
      hideDropdown(notify: false);
    }
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  void hideDropdown({bool notify = true}) {
    if (!_isDropdownOpen && _placeSuggestions.isEmpty) return;
    _isDropdownOpen = false;
    _placeSuggestions = const <PlaceSuggestion>[];
    if (notify) {
      notifyListeners();
    }
  }

  void onDirectUrlChanged(String raw, {required AppLocalizations l10n}) {
    _directInputDebounce?.cancel();
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      _linkResult = const ModeResultState.empty();
    }
    notifyListeners();
  }

  Future<void> convertDirectUrl({
    required AppLocalizations l10n,
    bool showFeedbackToast = true,
  }) async {
    _directInputDebounce?.cancel();
    final raw = urlController.text.trim();
    if (raw.isEmpty) {
      _linkResult = const ModeResultState.empty();
      notifyListeners();
      if (showFeedbackToast) {
        showToast(l10n.toastPasteFirst, type: ToastType.warn);
      }
      return;
    }

    final needsNetwork = UrlConverterService.isMapsShortLink(raw) &&
        UrlConverterService.parsePlaceIdFromText(raw) == null;

    if (needsNetwork) {
      _isResolvingLink = true;
      notifyListeners();
    }

    final isOnline = await _hardwareBridge.isNetworkConnected();
    final analysis = await _urlConverterService.analyzeAndConvert(
      raw,
      isOnline: isOnline,
      explicitConvertAction: showFeedbackToast,
    );

    _isResolvingLink = false;

    if (analysis.errorType != null) {
      if (showFeedbackToast || needsNetwork) {
        switch (analysis.errorType!) {
          case DirectUrlError.empty:
            showToast(l10n.toastPasteFirst, type: ToastType.warn);
          case DirectUrlError.noInternet:
            showToast(l10n.toastNoInternet, type: ToastType.warn);
          case DirectUrlError.invalidPlaceId:
            showToast(l10n.toastInvalid, type: ToastType.error);
        }
      }
      notifyListeners();
      return;
    }

    if (analysis.reviewUrl != null && analysis.reviewUrl!.isNotEmpty) {
      _linkResult = ModeResultState(
        reviewUrl: analysis.reviewUrl,
        locationUrl: analysis.locationUrl,
        placeId: analysis.placeId,
        activeType: LinkOutputType.review,
        isResultActive: true,
      );
      notifyListeners();
      if (showFeedbackToast && analysis.isConvertedMapsPlace) {
        showToast(l10n.toastSuccess, type: ToastType.success);
      }
    } else {
      notifyListeners();
    }
  }

  void clearDirectUrl(AppLocalizations l10n) {
    _directInputDebounce?.cancel();
    urlController.clear();
    _linkResult = const ModeResultState.empty();
    notifyListeners();
    showToast(l10n.toastCleared, type: ToastType.trash);
  }

  Future<void> pasteFromClipboard(AppLocalizations l10n) async {
    try {
      final clip = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clip?.text?.trim() ?? '';
      if (text.isEmpty) {
        showToast(l10n.toastEmptyClip, type: ToastType.warn);
        return;
      }
      _activeMode = AppInputMode.link;
      urlController.text = text;
      urlController.selection = TextSelection.collapsed(offset: text.length);
      showToast(l10n.toastPasted, type: ToastType.paste);
      notifyListeners();
    } catch (_) {
      showToast(l10n.toastClipDenied, type: ToastType.paste);
    }
  }

  void setLinkType(LinkOutputType type) {
    final current = currentResult;
    if (!current.canSwitchLinkType || current.activeType == type) return;

    if (_activeMode == AppInputMode.link) {
      _linkResult = _linkResult.copyWith(activeType: type);
    } else {
      _searchResult = _searchResult.copyWith(activeType: type);
    }
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  void onSearchQueryChanged(String raw, {required AppLocalizations l10n}) {
    _searchDebounce?.cancel();
    final trimmed = raw.trim();

    if (UrlConverterService.looksLikeUrlOrPlaceIdInSearch(trimmed)) {
      _activeMode = AppInputMode.link;
      urlController.text = trimmed;
      urlController.selection = TextSelection.collapsed(offset: trimmed.length);
      searchController.clear();
      hideDropdown(notify: false);
      notifyListeners();
      showToast(l10n.toastPasted, type: ToastType.paste);
      return;
    }

    if (trimmed.length < 2) {
      _isSearchingPlaces = false;
      hideDropdown(notify: false);
      notifyListeners();
      return;
    }

    notifyListeners();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () async {
      _isSearchingPlaces = true;
      notifyListeners();

      final res = await _placesService.fetchSuggestions(
        trimmed,
        languageCode: _locale.languageCode,
      );

      _isSearchingPlaces = false;
      if (searchController.text.trim() != trimmed) {
        notifyListeners();
        return;
      }

      if (res.rateLimited) {
        hideDropdown(notify: false);
        notifyListeners();
        showToast(l10n.toastHourlyLimit, type: ToastType.warn);
        return;
      }

      _placeSuggestions = res.suggestions;
      _isDropdownOpen = res.suggestions.isNotEmpty;
      notifyListeners();
    });
  }

  void selectPlaceSuggestion(
    PlaceSuggestion suggestion, {
    required AppLocalizations l10n,
  }) {
    _searchDebounce?.cancel();
    hideDropdown(notify: false);

    final label = suggestion.displayLabel;
    searchController.text = label;
    searchController.selection = TextSelection.collapsed(offset: label.length);
    _placesService.resetSessionToken();

    final reviewUrl = UrlConverterService.buildReviewUrl(suggestion.placeId);
    final locationUrl =
        UrlConverterService.buildLocationUrl(suggestion.placeId);

    _searchResult = ModeResultState(
      reviewUrl: reviewUrl,
      locationUrl: locationUrl,
      placeId: suggestion.placeId,
      activeType: LinkOutputType.review,
      isResultActive: true,
    );
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
    showToast(l10n.toastSelectSuccess, type: ToastType.success);
  }

  void clearSearchInput({AppLocalizations? l10n}) {
    _searchDebounce?.cancel();
    searchController.clear();
    _isSearchingPlaces = false;
    hideDropdown(notify: false);
    _searchResult = const ModeResultState.empty();
    notifyListeners();
    if (l10n != null) {
      showToast(l10n.toastCleared, type: ToastType.trash);
    }
  }

  Future<void> importUrlFromNfcTag(String url, AppLocalizations l10n) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    _activeMode = AppInputMode.link;
    urlController.text = trimmed;
    urlController.selection = TextSelection.collapsed(offset: trimmed.length);
    await convertDirectUrl(l10n: l10n, showFeedbackToast: false);
    showToast(l10n.toastNfcReadSuccess, type: ToastType.success);
  }

  Future<void> copyActiveLink(AppLocalizations l10n) async {
    final url = activeGeneratedUrl;
    if (url == null || url.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: url));
    unawaited(_hardwareBridge.triggerLightHaptic());

    _copiedResetTimer?.cancel();
    _isCopiedFeedback = true;
    notifyListeners();
    showToast(l10n.toastCopied, type: ToastType.copy);

    _copiedResetTimer = Timer(const Duration(seconds: 2), () {
      _isCopiedFeedback = false;
      notifyListeners();
    });
  }

  Future<void> openActiveLink() async {
    final url = activeGeneratedUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> shareActiveLink(AppLocalizations l10n) async {
    final url = activeGeneratedUrl;
    if (url == null || url.isEmpty) return;
    try {
      await Share.share(url, subject: l10n.shareTitle);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      showToast(l10n.toastShareCopied, type: ToastType.copy);
    }
  }

  Future<void> openGithubRepository() async {
    final uri = Uri.parse('https://github.com/zaid-a-salameh/quick-nfc');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String resultHeaderLabel(AppLocalizations l10n) {
    final res = currentResult;
    if (res.placeId != null && res.placeId!.isNotEmpty) {
      return res.activeType == LinkOutputType.location
          ? l10n.resultLabelLocation
          : l10n.resultLabelReview;
    }
    return res.isDirectReviewUrl
        ? l10n.resultLabelReview
        : l10n.resultLabelCustom;
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _directInputDebounce?.cancel();
    _searchDebounce?.cancel();
    _copiedResetTimer?.cancel();
    urlController.dispose();
    searchController.dispose();
    toastNotifier.dispose();
    super.dispose();
  }
}
