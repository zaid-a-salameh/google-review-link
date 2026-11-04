import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/services/hardware_bridge_service.dart';
import 'data/services/preferences_service.dart';
import 'domain/models/toast_message.dart';
import 'l10n/app_localizations.dart';
import 'ui/core/theme/app_colors.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/widgets/toast_banner_overlay.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/home/widgets/home_screen.dart';
import 'ui/features/nfc/view_models/nfc_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.darkOverlayStyle);

  final preferencesService = await PreferencesService.create();
  final hardwareBridge = HardwareBridgeService();

  runApp(
    ReviewLinkGeneratorApp(
      preferencesService: preferencesService,
      hardwareBridge: hardwareBridge,
    ),
  );
}

class ReviewLinkGeneratorApp extends StatefulWidget {
  const ReviewLinkGeneratorApp({
    super.key,
    required this.preferencesService,
    this.hardwareBridge,
    this.homeViewModel,
    this.nfcViewModel,
    this.enableAutoOnboarding = true,
    this.enableStartupUpdateCheck = true,
  });

  final PreferencesService preferencesService;
  final HardwareBridgeService? hardwareBridge;
  final HomeViewModel? homeViewModel;
  final NfcViewModel? nfcViewModel;
  final bool enableAutoOnboarding;
  final bool enableStartupUpdateCheck;

  @override
  State<ReviewLinkGeneratorApp> createState() => _ReviewLinkGeneratorAppState();
}

class _ReviewLinkGeneratorAppState extends State<ReviewLinkGeneratorApp>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final HomeViewModel _homeViewModel;
  late final NfcViewModel _nfcViewModel;
  late final bool _ownsHomeVm;
  late final bool _ownsNfcVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final bridge = widget.hardwareBridge ?? HardwareBridgeService();

    if (widget.homeViewModel != null) {
      _homeViewModel = widget.homeViewModel!;
      _ownsHomeVm = false;
    } else {
      _homeViewModel = HomeViewModel(
        preferencesService: widget.preferencesService,
        hardwareBridge: bridge,
      );
      _ownsHomeVm = true;
    }

    if (widget.nfcViewModel != null) {
      _nfcViewModel = widget.nfcViewModel!;
      _ownsNfcVm = false;
    } else {
      _nfcViewModel = NfcViewModel(
        hardwareBridge: bridge,
        onUrlTagRead: (String url) async {
          final navContext = _navigatorKey.currentContext;
          if (navContext == null) return;
          final l10n = AppLocalizations.of(navContext);
          if (l10n != null) {
            await _homeViewModel.importUrlFromNfcTag(url, l10n);
          }
        },
      );
      _ownsNfcVm = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ownsNfcVm) _nfcViewModel.dispose();
    if (_ownsHomeVm) _homeViewModel.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _homeViewModel,
      builder: (BuildContext context, _) {
        final locale = _homeViewModel.locale;
        final themeMode = _homeViewModel.themeMode;
        final platformBrightness = MediaQuery.platformBrightnessOf(context);
        final effectiveLight = themeMode == ThemeMode.light ||
            (themeMode == ThemeMode.system &&
                platformBrightness == Brightness.light);
        AppColors.isLight = effectiveLight;
        SystemChrome.setSystemUIOverlayStyle(AppTheme.currentOverlayStyle);

        return MaterialApp(
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (ctx) =>
              AppLocalizations.of(ctx)?.appTitle ?? 'Quick NFC',
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.buildLightTheme(locale),
          darkTheme: AppTheme.buildDarkTheme(locale),
          themeMode: themeMode,
          themeAnimationDuration: const Duration(milliseconds: 320),
          builder: (BuildContext context, Widget? child) {
            AppColors.isLight = effectiveLight;
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ?child,
                ValueListenableBuilder<ToastMessage?>(
                  valueListenable: _homeViewModel.toastNotifier,
                  builder: (context, toast, _) =>
                      ToastBannerOverlay(toast: toast),
                ),
              ],
            );
          },
          home: HomeScreen(
            homeViewModel: _homeViewModel,
            nfcViewModel: _nfcViewModel,
            enableAutoOnboarding: widget.enableAutoOnboarding,
            enableStartupUpdateCheck: widget.enableStartupUpdateCheck,
          ),
        );
      },
    );
  }
}
