import 'package:flutter/material.dart';

import '../../../../data/services/hardware_bridge_service.dart';
import '../../../../domain/models/toast_message.dart';
import '../../../../domain/models/wifi_credentials.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lang_roll_text.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../qr/qr_modal_dialog.dart';
import '../view_models/nfc_view_model.dart';

class WifiWizardView extends StatelessWidget {
  const WifiWizardView({
    super.key,
    required this.viewModel,
    required this.hardwareBridge,
    required this.onShowToast,
    required this.onRequestCloseModal,
  });

  final NfcViewModel viewModel;
  final HardwareBridgeService hardwareBridge;
  final void Function(String message, {ToastType type}) onShowToast;
  final VoidCallback onRequestCloseModal;

  void _handleNextOrWrite(BuildContext context, AppLocalizations l10n) {
    FocusManager.instance.primaryFocus?.unfocus();
    final isFinalStep = viewModel.wifiStep == 3;
    final validationError = viewModel.advanceWifiWizardOrValidate();

    if (validationError != null) {
      if (validationError == 'EMPTY_SSID') {
        onShowToast(l10n.toastEnterSsid, type: ToastType.warn);
      } else if (validationError == 'SHORT_PASSWORD') {
        onShowToast(l10n.toastWifiPassMinLength, type: ToastType.warn);
      } else if (validationError == 'WPA_REQUIRED') {
        onShowToast(l10n.toastWifiWpaRequired, type: ToastType.warn);
      }
      return;
    }

    if (isFinalStep) {
      viewModel.startWifiNfcWriteFromWizard(resetBatch: true);
    }
  }

  void _handleShowWifiQr(BuildContext context, AppLocalizations l10n) {
    FocusManager.instance.primaryFocus?.unfocus();
    final err = viewModel.validateWifiStep3ForAction();
    if (err != null) {
      if (err == 'EMPTY_SSID') {
        onShowToast(l10n.toastEnterSsid, type: ToastType.warn);
      } else {
        onShowToast(l10n.toastWifiWpaRequired, type: ToastType.warn);
      }
      return;
    }

    final creds = viewModel.resolveEffectiveWifiCredentials();
    showWifiQrCodeModal(
      context: context,
      credentials: creds,
      hardwareBridge: hardwareBridge,
      onShowToast: onShowToast,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final step = viewModel.wifiStep;

    final stepTitle = step == 1
        ? l10n.wifiStep1Title
        : (step == 2 ? l10n.wifiStep2Title : l10n.wifiStep3Title);
    final stepDesc = step == 1
        ? l10n.wifiStep1Desc
        : (step == 2 ? l10n.wifiStep2Desc : l10n.wifiStep3Desc);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: viewModel.closeWifiDropdown,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: -6,
            right: -6,
            child: PressableScale(
              key: const Key('btn_close_wifi_modal'),
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onRequestCloseModal();
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.subtleButtonBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: Center(
                  child: AppSvgIcons.closeX(
                    size: 13,
                    color: AppColors.textSub,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Top Amber Wi-Fi Emblem
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.wifiAmberGradient,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.amberWifi.withValues(alpha: 0.38),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: AppSvgIcons.wifiWaves(
                size: 27,
                color: const Color(0xFF140F0A),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 1 - 2 - 3 Stepper Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStepNode(1, step),
              _buildStepConnector(step > 1),
              _buildStepNode(2, step),
              _buildStepConnector(step > 2),
              _buildStepNode(3, step),
            ],
          ),
          const SizedBox(height: 16),

          // Step Title & Description
          LangRollText(
            stepTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 19.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          LangRollText(
            stepDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 13.2,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          // Directional Step Pane
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) {
                final isEntering = child.key == ValueKey<int>(step);
                final rtlSign = isRtl ? -1.0 : 1.0;
                final dx = viewModel.wifiStepDirection * rtlSign * 0.16;
                final offset = isEntering ? Offset(dx, 0) : Offset(-dx, 0);
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: offset,
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(step),
                child: _buildStepPane(context, step, l10n),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Step Footer Actions
          if (step < 3)
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: PressableScale(
                    key: const Key('btn_wifi_back'),
                    onTap: () async {
                      final handled = await viewModel.handleCancelOrBack();
                      if (!handled) onRequestCloseModal();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.subtleButtonBg,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.borderGlass),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        step == 1 ? l10n.pwdCancel : l10n.wifiBack,
                        style: TextStyle(
                          color: AppColors.textSub,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 6,
                  child: PressableScale(
                    key: const Key('btn_wifi_next'),
                    onTap: () => _handleNextOrWrite(context, l10n),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.wifiAmberGradient,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.amberWifi.withValues(alpha: 0.34),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            l10n.wifiNext,
                            style: const TextStyle(
                              color: Color(0xFF140F0A),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isRtl
                                ? Icons.arrow_back_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                            color: const Color(0xFF140F0A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: PressableScale(
                        key: const Key('btn_wifi_write_nfc'),
                        onTap: () => _handleNextOrWrite(context, l10n),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.wifiAmberGradient,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color:
                                    AppColors.amberWifi.withValues(alpha: 0.34),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AppSvgIcons.nfcTagSquare(
                                size: 17,
                                color: const Color(0xFF140F0A),
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    l10n.wifiWriteTag,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF140F0A),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: PressableScale(
                        key: const Key('btn_wifi_wizard_qr'),
                        onTap: () => _handleShowWifiQr(context, l10n),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.amberWifi.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                                  AppColors.amberWifi.withValues(alpha: 0.42),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AppSvgIcons.qrGrid(
                                size: 16,
                                color: AppColors.amberWifiLight,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    l10n.wifiQrBtn,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.amberWifiLight,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      height: 1.15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PressableScale(
                  key: const Key('btn_wifi_step3_back'),
                  onTap: () async {
                    final handled = await viewModel.handleCancelOrBack();
                    if (!handled) onRequestCloseModal();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.subtleButtonBg,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.wifiBack,
                      style: TextStyle(
                        color: AppColors.textSub,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
  }

  Widget _buildStepPane(
    BuildContext context,
    int step,
    AppLocalizations l10n,
  ) {
    if (step == 1) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: viewModel.wifiSsidController,
        builder: (context, value, _) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.amberWifi.withValues(alpha: 0.35),
              ),
            ),
            child: TextField(
              key: const Key('input_wifi_ssid'),
              controller: viewModel.wifiSsidController,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onSubmitted: (_) => _handleNextOrWrite(context, l10n),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: l10n.wifiSsidPlaceholder,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(13),
                  child: AppSvgIcons.wifiWaves(
                    size: 18,
                    color: AppColors.amberWifiLight,
                  ),
                ),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: viewModel.clearWifiSsid,
                        icon: AppSvgIcons.closeX(
                          size: 16,
                          color: AppColors.textSub,
                        ),
                      ),
              ),
            ),
          );
        },
      );
    }

    if (step == 2) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.amberWifi.withValues(alpha: 0.35),
          ),
        ),
        child: TextField(
          key: const Key('input_wifi_password'),
          controller: viewModel.wifiPasswordController,
          obscureText: viewModel.isWifiPasswordObscured,
          textInputAction: TextInputAction.next,
          onTapOutside: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          onSubmitted: (_) => _handleNextOrWrite(context, l10n),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: l10n.wifiPasswordPlaceholder,
            hintStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(13),
              child: AppSvgIcons.lockClosed(
                size: 18,
                color: AppColors.amberWifiLight,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: viewModel.toggleWifiPasswordVisibility,
              icon: viewModel.isWifiPasswordObscured
                  ? AppSvgIcons.eyeOpen(size: 19, color: AppColors.textSub)
                  : AppSvgIcons.eyeClosed(
                      size: 19,
                      color: AppColors.amberWifiLight,
                    ),
            ),
          ),
        ),
      );
    }

    // Step 3: Custom Security Selector Dropdown
    final selected = viewModel.wifiEncryption;
    final selectedLabel = selected == WifiEncryption.open
        ? l10n.wifiEncOpen
        : (selected == WifiEncryption.wep ? l10n.wifiEncWep : l10n.wifiEncWpa);
    final selectedSub = selected == WifiEncryption.open
        ? l10n.wifiEncOpenSub
        : (selected == WifiEncryption.wep
            ? l10n.wifiEncWepSub
            : l10n.wifiEncWpaSub);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PressableScale(
          key: const Key('trigger_wifi_encryption'),
          onTap: viewModel.toggleWifiDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: viewModel.isWifiDropdownOpen
                    ? AppColors.amberWifiLight
                    : AppColors.amberWifi.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.amberWifi.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _encryptionIcon(selected, AppColors.amberWifiLight),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        selectedLabel,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedSub,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: viewModel.isWifiDropdownOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.amberWifiLight,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: !viewModel.isWifiDropdownOpen
              ? const SizedBox.shrink()
              : Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownMenuBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.amberWifi.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildEncOption(
                        enc: WifiEncryption.wpa,
                        title: l10n.wifiEncWpa,
                        sub: l10n.wifiEncWpaSub,
                        isSelected: selected == WifiEncryption.wpa,
                      ),
                      Divider(height: 1, color: AppColors.borderGlass),
                      _buildEncOption(
                        enc: WifiEncryption.wep,
                        title: l10n.wifiEncWep,
                        sub: l10n.wifiEncWepSub,
                        isSelected: selected == WifiEncryption.wep,
                      ),
                      Divider(height: 1, color: AppColors.borderGlass),
                      _buildEncOption(
                        enc: WifiEncryption.open,
                        title: l10n.wifiEncOpen,
                        sub: l10n.wifiEncOpenSub,
                        isSelected: selected == WifiEncryption.open,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEncOption({
    required WifiEncryption enc,
    required String title,
    required String sub,
    required bool isSelected,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => viewModel.selectWifiEncryption(enc),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        color: isSelected
            ? AppColors.amberWifi.withValues(alpha: 0.12)
            : Colors.transparent,
        child: Row(
          children: <Widget>[
            _encryptionIcon(
              enc,
              isSelected ? AppColors.amberWifiLight : AppColors.textSub,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.amberWifiLight
                          : AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AppSvgIcons.checkmark(size: 16, color: AppColors.amberWifiLight),
          ],
        ),
      ),
    );
  }

  Widget _encryptionIcon(WifiEncryption enc, Color color) {
    switch (enc) {
      case WifiEncryption.wpa:
        return AppSvgIcons.lockClosed(size: 18, color: color);
      case WifiEncryption.wep:
        return AppSvgIcons.wepKey(size: 18, color: color);
      case WifiEncryption.open:
        return AppSvgIcons.lockOpen(size: 18, color: color);
    }
  }

  Widget _buildStepNode(int stepNumber, int currentStep) {
    final isCurrent = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent
            ? AppColors.amberWifi
            : (isCompleted
                ? AppColors.amberWifi.withValues(alpha: 0.22)
                : AppColors.subtleButtonBg),
        border: Border.all(
          color: (isCurrent || isCompleted)
              ? AppColors.amberWifi
              : AppColors.borderGlass,
          width: 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? AppSvgIcons.checkmark(size: 13, color: AppColors.amberWifiLight)
          : Text(
              '$stepNumber',
              style: TextStyle(
                color:
                    isCurrent ? const Color(0xFF140F0A) : AppColors.textMuted,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }

  Widget _buildStepConnector(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: 30,
      height: 2.2,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: active ? AppColors.amberWifi : AppColors.borderGlass,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
