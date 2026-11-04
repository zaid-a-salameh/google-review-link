import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._prefs);

  static const String _keyLanguage = 'app_lang';
  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyOnboardingCompleted =
      'review_link_flutter_onboarding_v1';

  static const List<String> supportedThemeModes = <String>[
    'system',
    'dark',
    'light',
  ];

  static const List<String> supportedLanguages = <String>[
    'ar',
    'en',
    'es',
    'fr',
    'de',
    'zh',
    'hi',
    'pt',
    'ru',
    'ja',
  ];

  final SharedPreferences _prefs;

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  String getSavedLanguageCode() {
    final saved = _prefs.getString(_keyLanguage);
    if (saved != null && supportedLanguages.contains(saved)) {
      return saved;
    }
    return 'en';
  }

  Future<void> setLanguageCode(String code) async {
    final validCode = supportedLanguages.contains(code) ? code : 'en';
    await _prefs.setString(_keyLanguage, validCode);
  }

  String getSavedThemeMode() {
    final saved = _prefs.getString(_keyThemeMode);
    if (saved != null && supportedThemeModes.contains(saved)) {
      return saved;
    }
    return 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final validMode = supportedThemeModes.contains(mode) ? mode : 'system';
    await _prefs.setString(_keyThemeMode, validMode);
  }

  bool get isOnboardingCompleted {
    final obj = _prefs.get(_keyOnboardingCompleted);
    if (obj is bool) return obj;
    if (obj is String) return obj == '1' || obj == 'true';
    return false;
  }

  Future<void> markOnboardingCompleted() async {
    await _prefs.setBool(_keyOnboardingCompleted, true);
  }
}
