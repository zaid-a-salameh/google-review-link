import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ambient_glow_scaffold.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/sliding_segmented_control.dart';
import '../../home/view_models/home_view_model.dart';

class AppLanguageItem {
  const AppLanguageItem({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.flag,
    this.fontFamily,
    this.isFullySupported = false,
  });

  final String code;
  final String nativeName;
  final String englishName;
  final String flag;
  final String? fontFamily;
  final bool isFullySupported;
}

const List<AppLanguageItem> kTop10Languages = <AppLanguageItem>[
  AppLanguageItem(
    code: 'ar',
    nativeName: 'العربية',
    englishName: 'Arabic',
    flag: '🇸🇦',
    fontFamily: 'Cairo',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'en',
    nativeName: 'English',
    englishName: 'English (US)',
    flag: '🇺🇸',
    fontFamily: 'Inter',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'es',
    nativeName: 'Español',
    englishName: 'Spanish',
    flag: '🇪🇸',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'fr',
    nativeName: 'Français',
    englishName: 'French',
    flag: '🇫🇷',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'de',
    nativeName: 'Deutsch',
    englishName: 'German',
    flag: '🇩🇪',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'zh',
    nativeName: '简体中文',
    englishName: 'Chinese (Simplified)',
    flag: '🇨🇳',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'hi',
    nativeName: 'हिन्दी',
    englishName: 'Hindi',
    flag: '🇮🇳',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'pt',
    nativeName: 'Português',
    englishName: 'Portuguese',
    flag: '🇧🇷',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'ru',
    nativeName: 'Русский',
    englishName: 'Russian',
    flag: '🇷🇺',
    isFullySupported: true,
  ),
  AppLanguageItem(
    code: 'ja',
    nativeName: '日本語',
    englishName: 'Japanese',
    flag: '🇯🇵',
    isFullySupported: true,
  ),
];

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  bool _isLanguageDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mounted) {
      setState(() {});
    }
  }

  AppLanguageItem _resolveActiveLanguage(String code) {
    return kTop10Languages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => kTop10Languages[1],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (BuildContext context, _) {
        final vm = widget.viewModel;
        final isArabic = vm.isArabic;
        final activeLang = _resolveActiveLanguage(vm.selectedLanguageCode);
        final activeThemeMode = vm.selectedThemeMode;
        final themeMode = vm.themeMode;
        final isLight = themeMode == ThemeMode.light ||
            (themeMode == ThemeMode.system &&
                platformBrightness == Brightness.light);
        AppColors.isLight = isLight;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.currentOverlayStyle,
          child: AmbientGlowScaffold(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: <Widget>[
                      // Top App Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Row(
                          children: <Widget>[
                            PressableScale(
                              key: const Key('btn_settings_back'),
                              onTap: () => Navigator.of(context).maybePop(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.topBarButtonBg,
                                  borderRadius: BorderRadius.circular(13),
                                  border:
                                      Border.all(color: AppColors.borderGlass),
                                ),
                                child: Center(
                                  child: AnimatedRotation(
                                    turns: isRtl ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeOutCubic,
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      color: AppColors.primaryLight,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              child: Text(
                                l10n.settingsTitle,
                                key: ValueKey<String>(
                                  '${l10n.settingsTitle}_$isLight',
                                ),
                                style: TextStyle(
                                  fontFamily: isArabic ? 'Cairo' : 'Inter',
                                  color: AppColors.textPrimary,
                                  fontSize: 19.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content Scroll View with Smooth Animated Switcher
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 340),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: isRtl
                                      ? const Offset(-0.03, 0)
                                      : const Offset(0.03, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: KeyedSubtree(
                            key: ValueKey<String>(vm.selectedLanguageCode),
                            child: SingleChildScrollView(
                              key: ValueKey<bool>(isLight),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                // Section: Preferences
                                _buildSectionHeader(
                                  l10n.settingsGeneralSection,
                                  isArabic,
                                ),
                                const SizedBox(height: 8),
                                GlassCard(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      // 1. Language Setting Header
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.translate_rounded,
                                                color: AppColors.primaryLight,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  l10n.settingsLanguageLabel,
                                                  style: TextStyle(
                                                    fontFamily: isArabic
                                                        ? 'Cairo'
                                                        : 'Inter',
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  l10n.settingsLanguageSub,
                                                  style: TextStyle(
                                                    fontFamily: isArabic
                                                        ? 'Cairo'
                                                        : 'Inter',
                                                    color: AppColors.textMuted,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),

                                      // Dropdown Trigger Selector
                                      PressableScale(
                                        key: const Key('btn_language_dropdown'),
                                        onTap: () {
                                          setState(() {
                                            _isLanguageDropdownOpen =
                                                !_isLanguageDropdownOpen;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.inputBg,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: _isLanguageDropdownOpen
                                                  ? AppColors.primaryLight
                                                      .withValues(alpha: 0.55)
                                                  : AppColors.borderGlass,
                                              width: _isLanguageDropdownOpen
                                                  ? 1.4
                                                  : 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                activeLang.flag,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          activeLang.nativeName,
                                                          style: TextStyle(
                                                            fontFamily: activeLang
                                                                    .fontFamily ??
                                                                (isArabic
                                                                    ? 'Cairo'
                                                                    : 'Inter'),
                                                            color: AppColors
                                                                .textPrimary,
                                                            fontSize: 14.5,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        if (!activeLang
                                                            .isFullySupported) ...<
                                                            Widget>[
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 6,
                                                              vertical: 2,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .primary
                                                                  .withValues(
                                                                alpha: 0.16,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                6,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: AppColors
                                                                    .primaryLight
                                                                    .withValues(
                                                                  alpha: 0.35,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'English UI',
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .primaryLight,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                    Text(
                                                      activeLang.englishName,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.textMuted,
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              AnimatedRotation(
                                                turns: _isLanguageDropdownOpen
                                                    ? 0.5
                                                    : 0.0,
                                                duration: const Duration(
                                                  milliseconds: 420,
                                                ),
                                                curve: Curves.easeInOutCubic,
                                                child: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: AppColors.primaryLight,
                                                  size: 22,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Animated Dropdown Menu List (Smoother, Slower Unfold)
                                      AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 450),
                                        curve: Curves.easeInOutCubic,
                                        alignment: Alignment.topCenter,
                                        child: _isLanguageDropdownOpen
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.dropdownMenuBg,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color:
                                                        AppColors.borderGlass,
                                                  ),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: AppColors.isLight
                                                          ? const Color(
                                                              0x1A000000,
                                                            )
                                                          : const Color(
                                                              0x66000000,
                                                            ),
                                                      blurRadius: 16,
                                                      offset:
                                                          const Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      for (int i = 0;
                                                          i <
                                                              kTop10Languages
                                                                  .length;
                                                          i++) ...<Widget>[
                                                        if (i > 0)
                                                          Divider(
                                                            height: 1,
                                                            color: AppColors
                                                                .borderGlass,
                                                            indent: 14,
                                                            endIndent: 14,
                                                          ),
                                                        _LanguageItemTile(
                                                          key: Key(
                                                            'settings_lang_${kTop10Languages[i].code}',
                                                          ),
                                                          item: kTop10Languages[
                                                              i],
                                                          isSelected:
                                                              kTop10Languages[i]
                                                                      .code ==
                                                                  vm.selectedLanguageCode,
                                                          onTap: () {
                                                            setState(() {
                                                              _isLanguageDropdownOpen =
                                                                  false;
                                                            });
                                                            vm.switchLanguage(
                                                              kTop10Languages[i]
                                                                  .code,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),

                                      const SizedBox(height: 18),
                                      Divider(
                                        height: 1,
                                        color: AppColors.borderGlass,
                                      ),
                                      const SizedBox(height: 18),

                                      // 2. Theme / Appearance Setting
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.palette_outlined,
                                                color: AppColors.primaryLight,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  l10n.settingsThemeLabel,
                                                  style: TextStyle(
                                                    fontFamily: isArabic
                                                        ? 'Cairo'
                                                        : 'Inter',
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  l10n.settingsThemeSub,
                                                  style: TextStyle(
                                                    fontFamily: isArabic
                                                        ? 'Cairo'
                                                        : 'Inter',
                                                    color: AppColors.textMuted,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),

                                      // 3-Option Sliding Theme Selector (System / Dark / Light)
                                      SlidingSegmentedControl(
                                        height: 62,
                                        borderRadius: 16,
                                        iconAboveLabel: true,
                                        fontSize: 12.5,
                                        selectedIndex: activeThemeMode == 'dark'
                                            ? 1
                                            : (activeThemeMode == 'light' ? 2 : 0),
                                        onChanged: (index) {
                                          final mode = index == 1
                                              ? 'dark'
                                              : (index == 2 ? 'light' : 'system');
                                          vm.switchThemeMode(mode);
                                        },
                                        items: <SegmentedTabItem>[
                                          SegmentedTabItem(
                                            semanticKey: const Key(
                                              'btn_theme_system',
                                            ),
                                            label: l10n.settingsThemeSystem,
                                            iconBuilder: (isSelected) => Icon(
                                              Icons.brightness_auto_rounded,
                                              size: 19,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textSub,
                                            ),
                                          ),
                                          SegmentedTabItem(
                                            semanticKey: const Key(
                                              'btn_theme_dark',
                                            ),
                                            label: l10n.settingsThemeDark,
                                            iconBuilder: (isSelected) => Icon(
                                              Icons.dark_mode_rounded,
                                              size: 19,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textSub,
                                            ),
                                          ),
                                          SegmentedTabItem(
                                            semanticKey: const Key(
                                              'btn_theme_light',
                                            ),
                                            label: l10n.settingsThemeLight,
                                            iconBuilder: (isSelected) => Icon(
                                              Icons.light_mode_rounded,
                                              size: 19,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textSub,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Section: About
                                _buildSectionHeader(
                                  l10n.settingsAboutSection,
                                  isArabic,
                                ),
                                const SizedBox(height: 8),
                                GlassCard(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppColors.primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.32),
                                                  blurRadius: 14,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: AppSvgIcons.appLogo(
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  l10n.appTitle,
                                                  style: TextStyle(
                                                    fontFamily: isArabic
                                                        ? 'Cairo'
                                                        : 'Inter',
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${l10n.settingsVersionLabel} ${vm.currentAppVersion}',
                                                  style: TextStyle(
                                                    fontFamily: 'JetBrainsMono',
                                                    color: AppColors.textSub,
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Divider(
                                        height: 1,
                                        color: AppColors.borderGlass,
                                      ),
                                      const SizedBox(height: 12),

                                      // GitHub Link Button
                                      PressableScale(
                                        key: const Key('btn_settings_github'),
                                        onTap: vm.openGithubRepository,
                                        child: Container(
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.subtleButtonBg,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppColors.borderGlass,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              AppSvgIcons.githubOctocat(
                                                size: 17,
                                                color: AppColors.textPrimary,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                l10n.fabGithubLabel,
                                                style: TextStyle(
                                                  fontFamily: isArabic
                                                      ? 'Cairo'
                                                      : 'Inter',
                                                  color: AppColors.textPrimary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              AppSvgIcons.openExternal(
                                                size: 14,
                                                color: AppColors.textSub,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: isArabic ? 'Cairo' : 'Inter',
          color: AppColors.primaryLight,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _LanguageItemTile extends StatelessWidget {
  const _LanguageItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppLanguageItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.14)
            : Colors.transparent,
        child: Row(
          children: <Widget>[
            Text(
              item.flag,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        item.nativeName,
                        style: TextStyle(
                          fontFamily: item.fontFamily,
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      if (!item.isFullySupported) ...<Widget>[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.subtleButtonBg,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'English UI',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    item.englishName,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: AppSvgIcons.checkmark(size: 12, color: Colors.white),
                ),
              )
            else
              const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
