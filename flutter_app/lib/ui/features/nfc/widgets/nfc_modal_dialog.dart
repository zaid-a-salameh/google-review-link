import 'package:flutter/material.dart';

import '../../../../data/services/hardware_bridge_service.dart';
import '../../../../domain/models/nfc_models.dart';
import '../../../../domain/models/toast_message.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/morph_dialog.dart';
import '../view_models/nfc_view_model.dart';
import 'erase_confirm_view.dart';
import 'nfc_sensor_view.dart';
import 'perm_lock_confirm_view.dart';
import 'pin_security_view.dart';
import 'wifi_wizard_view.dart';

Future<void> showNfcOperationModal({
  required BuildContext context,
  required NfcViewModel viewModel,
  required HardwareBridgeService hardwareBridge,
  required void Function(String message, {ToastType type}) onShowToast,
}) {
  return showAppMorphDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => NfcModalDialog(
      viewModel: viewModel,
      hardwareBridge: hardwareBridge,
      onShowToast: onShowToast,
    ),
  );
}

class NfcModalDialog extends StatefulWidget {
  const NfcModalDialog({
    super.key,
    required this.viewModel,
    required this.hardwareBridge,
    required this.onShowToast,
  });

  final NfcViewModel viewModel;
  final HardwareBridgeService hardwareBridge;
  final void Function(String message, {ToastType type}) onShowToast;

  @override
  State<NfcModalDialog> createState() => _NfcModalDialogState();
}

class _NfcModalDialogState extends State<NfcModalDialog> {
  bool _allowImmediatePop = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.attachDialogCloser(_closeNow);
  }

  @override
  void dispose() {
    widget.viewModel.attachDialogCloser(null);
    super.dispose();
  }

  void _closeNow() {
    if (!mounted) return;
    setState(() => _allowImmediatePop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  Color _resolveBorderColor(NfcViewModel vm) {
    if (vm.subView == NfcSubView.sensor &&
        vm.sensorState == NfcSensorState.error) {
      return AppColors.danger.withValues(alpha: 0.42);
    }
    switch (vm.visualTheme) {
      case NfcVisualTheme.wifi:
        return AppColors.amberWifi.withValues(alpha: 0.36);
      case NfcVisualTheme.lock:
        return AppColors.pinkLock.withValues(alpha: 0.38);
      case NfcVisualTheme.permLock:
        return AppColors.danger.withValues(alpha: 0.40);
      case NfcVisualTheme.unlock:
        return AppColors.success.withValues(alpha: 0.38);
      case NfcVisualTheme.link:
        return AppColors.primaryLight.withValues(alpha: 0.30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (BuildContext context, _) {
        final vm = widget.viewModel;
        final borderColor = _resolveBorderColor(vm);

        return PopScope(
          canPop: _allowImmediatePop,
          onPopInvokedWithResult: (bool didPop, dynamic _) async {
            if (didPop) {
              if (vm.isDialogVisible) {
                await vm.closeAndResetSession();
              }
              return;
            }
            final handledInternally = await vm.handleCancelOrBack();
            if (!handledInternally) {
              _closeNow();
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
              ),
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 388),
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey<int>(vm.wifiCloneMorphTick),
                    tween: Tween<double>(
                      begin: vm.wifiCloneMorphTick > 0 ? 0.96 : 1.0,
                      end: 1.0,
                    ),
                    duration: const Duration(milliseconds: 340),
                    curve: Curves.easeOutBack,
                    builder: (context, scaleVal, child) => Transform.scale(
                      scale: scaleVal,
                      child: child,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                      decoration: BoxDecoration(
                        gradient: AppColors.modalGradient,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderColor, width: 1.15),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: borderColor.withValues(alpha: 0.22),
                            blurRadius: 36,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: AppColors.isLight
                                ? const Color(0x28000000)
                                : const Color(0x99000000),
                            blurRadius: 32,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: _buildActiveSubView(vm),
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

  Widget _buildActiveSubView(NfcViewModel vm) {
    switch (vm.subView) {
      case NfcSubView.sensor:
        return NfcSensorView(
          key: const ValueKey<NfcSubView>(NfcSubView.sensor),
          viewModel: vm,
          hardwareBridge: widget.hardwareBridge,
          onShowToast: widget.onShowToast,
          onRequestCloseModal: _closeNow,
        );
      case NfcSubView.pin:
        return PinSecurityView(
          key: const ValueKey<NfcSubView>(NfcSubView.pin),
          viewModel: vm,
          onShowToast: widget.onShowToast,
          onRequestCloseModal: _closeNow,
        );
      case NfcSubView.permConfirm:
        return PermLockConfirmView(
          key: const ValueKey<NfcSubView>(NfcSubView.permConfirm),
          viewModel: vm,
          onRequestCloseModal: _closeNow,
        );
      case NfcSubView.eraseConfirm:
        return EraseConfirmView(
          key: const ValueKey<NfcSubView>(NfcSubView.eraseConfirm),
          viewModel: vm,
          onRequestCloseModal: _closeNow,
        );
      case NfcSubView.wifiWizard:
        return WifiWizardView(
          key: const ValueKey<NfcSubView>(NfcSubView.wifiWizard),
          viewModel: vm,
          hardwareBridge: widget.hardwareBridge,
          onShowToast: widget.onShowToast,
          onRequestCloseModal: _closeNow,
        );
    }
  }
}
