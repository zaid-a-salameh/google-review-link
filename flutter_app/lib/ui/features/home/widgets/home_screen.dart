import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/models/toast_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ambient_glow_scaffold.dart';
import '../../nfc/view_models/nfc_view_model.dart';
import '../../nfc/widgets/nfc_modal_dialog.dart';
import '../../onboarding/onboarding_modal_dialog.dart';
import '../../qr/qr_modal_dialog.dart';
import '../../settings/widgets/settings_screen.dart';
import '../../updater/update_modal_dialog.dart';
import '../view_models/home_view_model.dart';
import 'card_tools_grid.dart';
import 'github_dock_button.dart';
import 'header_widget.dart';
import 'main_input_card.dart';
import 'result_card.dart';
import 'top_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.homeViewModel,
    required this.nfcViewModel,
    this.enableAutoOnboarding = true,
    this.enableStartupUpdateCheck = true,
  });

  final HomeViewModel homeViewModel;
  final NfcViewModel nfcViewModel;
  final bool enableAutoOnboarding;
  final bool enableStartupUpdateCheck;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final ScrollController _scrollController;
  Timer? _onboardingTimer;
  Timer? _smoothScrollTimer;
  String? _lastActiveUrl;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _lastActiveUrl = widget.homeViewModel.activeGeneratedUrl;
    WidgetsBinding.instance.addObserver(this);
    widget.homeViewModel.addListener(_handleViewModelUpdates);

    if (widget.enableAutoOnboarding &&
        widget.homeViewModel.shouldAutoShowOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _onboardingTimer = Timer(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          if (widget.homeViewModel.shouldAutoShowOnboarding) {
            _openOnboardingTour();
          }
        });
      });
    }

    if (widget.enableStartupUpdateCheck) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.homeViewModel.initializeStartupChecks();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.homeViewModel.removeListener(_handleViewModelUpdates);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _onboardingTimer?.cancel();
    _smoothScrollTimer?.cancel();
    super.dispose();
  }

  void _handleViewModelUpdates() {
    final currentUrl = widget.homeViewModel.activeGeneratedUrl;
    final isResultActive = widget.homeViewModel.currentResult.isResultActive;
    if (isResultActive &&
        currentUrl != null &&
        currentUrl.isNotEmpty &&
        currentUrl != _lastActiveUrl) {
      _scrollToBottomSmoothly();
    }
    _lastActiveUrl = currentUrl;
  }

  void _scrollToBottomSmoothly() {
    _smoothScrollTimer?.cancel();
    _smoothScrollTimer = Timer(const Duration(milliseconds: 220), () {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mounted) {
      setState(() {});
    }
  }

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  Future<void> _handleCheckUpdate() async {
    _unfocusAll();
    final l10n = AppLocalizations.of(context)!;
    final update = widget.homeViewModel.availableUpdate;

    if (update != null) {
      await showAppUpdateModal(
        context: context,
        release: update,
        currentVersion: widget.homeViewModel.currentAppVersion,
        onInstall: () => widget.homeViewModel.startUpdateDownload(l10n),
        onDismiss: () {},
      );
      if (mounted) _unfocusAll();
      return;
    }

    final newRelease = await widget.homeViewModel.checkForUpdatesManual(l10n);
    if (newRelease != null && mounted) {
      await showAppUpdateModal(
        context: context,
        release: newRelease,
        currentVersion: widget.homeViewModel.currentAppVersion,
        onInstall: () => widget.homeViewModel.startUpdateDownload(l10n),
        onDismiss: () {},
      );
      if (mounted) _unfocusAll();
    }
  }

  Future<void> _openOnboardingTour() async {
    _unfocusAll();
    await showOnboardingTourModal(
      context: context,
      onCompleted: widget.homeViewModel.markOnboardingSeen,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _openSettings() async {
    _unfocusAll();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(viewModel: widget.homeViewModel),
      ),
    );
    if (mounted) {
      _unfocusAll();
      setState(() {});
    }
  }

  Future<void> _handleWriteNfc(AppLocalizations l10n) async {
    _unfocusAll();
    final url = widget.homeViewModel.activeGeneratedUrl;
    if (url == null || url.isEmpty) {
      widget.homeViewModel.showToast(
        l10n.toastPasteFirst,
        type: ToastType.warn,
      );
      return;
    }
    widget.nfcViewModel.prepareWriteUrl(url);
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _handleReadNfc() async {
    _unfocusAll();
    widget.nfcViewModel.prepareReadCard();
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _handleOpenWifiWizard() async {
    _unfocusAll();
    widget.nfcViewModel.prepareWifiWizard();
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _handleOpenPinModal() async {
    _unfocusAll();
    widget.nfcViewModel.preparePinProtection();
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _handleOpenPermLockModal() async {
    _unfocusAll();
    widget.nfcViewModel.preparePermLockConfirm();
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  Future<void> _handleOpenEraseModal() async {
    _unfocusAll();
    widget.nfcViewModel.prepareEraseConfirm();
    await showNfcOperationModal(
      context: context,
      viewModel: widget.nfcViewModel,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  void _handleSupportTapped(AppLocalizations l10n) {
    _unfocusAll();
    widget.homeViewModel.showToast(
      l10n.toastSupportComingSoon,
      type: ToastType.info,
    );
  }

  Future<void> _handleOpenQrModal(AppLocalizations l10n) async {
    _unfocusAll();
    final url = widget.homeViewModel.activeGeneratedUrl;
    if (url == null || url.isEmpty) {
      widget.homeViewModel.showToast(
        l10n.toastPasteFirst,
        type: ToastType.warn,
      );
      return;
    }
    await showQrCodeModal(
      context: context,
      data: url,
      hardwareBridge: widget.homeViewModel.hardwareBridge,
      onShowToast: widget.homeViewModel.showToast,
    );
    if (mounted) _unfocusAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 40;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return ListenableBuilder(
      listenable: widget.homeViewModel,
      builder: (BuildContext context, _) {
        final vm = widget.homeViewModel;
        final themeMode = vm.themeMode;
        final isLight = themeMode == ThemeMode.light ||
            (themeMode == ThemeMode.system &&
                platformBrightness == Brightness.light);
        AppColors.isLight = isLight;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.currentOverlayStyle,
          child: PopScope(
            canPop: !vm.isDropdownOpen,
            onPopInvokedWithResult: (bool didPop, dynamic _) {
              if (!didPop && vm.isDropdownOpen) {
                vm.hideDropdown();
              }
            },
            child: AmbientGlowScaffold(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _unfocusAll,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TopBarWidget(
                              key: ValueKey<String>('top_bar_$isLight'),
                              currentVersion: vm.currentAppVersion,
                              hasUpdate: vm.availableUpdate != null,
                              isCheckingUpdate: vm.isCheckingUpdate,
                              onCheckUpdate: _handleCheckUpdate,
                              onOpenGuide: _openOnboardingTour,
                              onOpenSettings: _openSettings,
                            ),
                            HeaderWidget(
                              key: ValueKey<String>('header_$isLight'),
                            ),
                            MainInputCard(viewModel: vm),
                            CardToolsGrid(
                              key: ValueKey<String>('tools_grid_$isLight'),
                              onReadCard: _handleReadNfc,
                              onOpenWifiWizard: _handleOpenWifiWizard,
                              onOpenPinSecurity: _handleOpenPinModal,
                              onOpenErase: _handleOpenEraseModal,
                              onOpenPermLock: _handleOpenPermLockModal,
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              alignment: Alignment.topCenter,
                              child: ResultCard(
                                key: ValueKey<String>('result_card_$isLight'),
                                viewModel: vm,
                                onWriteNfc: () => _handleWriteNfc(l10n),
                                onOpenQr: () => _handleOpenQrModal(l10n),
                              ),
                            ),
                            if (!keyboardOpen)
                              GithubDockButton(
                                key: ValueKey<String>('github_dock_$isLight'),
                                onTapProject: vm.openGithubRepository,
                                onTapSupport: () => _handleSupportTapped(l10n),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
