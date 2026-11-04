import 'package:flutter/material.dart';

import '../../../../data/services/hardware_bridge_service.dart';
import '../../../../domain/models/nfc_models.dart';
import '../../../../domain/models/toast_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../qr/qr_modal_dialog.dart';
import '../view_models/nfc_view_model.dart';

class NfcSensorView extends StatefulWidget {
  const NfcSensorView({
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

  @override
  State<NfcSensorView> createState() => _NfcSensorViewState();
}

class _NfcSensorViewState extends State<NfcSensorView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    widget.viewModel.addListener(_syncPulseTicker);
    _syncPulseTicker();
  }

  @override
  void didUpdateWidget(covariant NfcSensorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_syncPulseTicker);
      widget.viewModel.addListener(_syncPulseTicker);
      _syncPulseTicker();
    }
  }

  void _syncPulseTicker() {
    if (!mounted) return;
    if (_isScanningState(widget.viewModel.sensorState)) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat();
      }
    } else if (_pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_syncPulseTicker);
    _pulseController.dispose();
    super.dispose();
  }

  bool _isScanningState(NfcSensorState s) {
    return s == NfcSensorState.ready ||
        s == NfcSensorState.readReady ||
        s == NfcSensorState.permLockReady ||
        s == NfcSensorState.eraseReady ||
        s == NfcSensorState.pwdLockReady ||
        s == NfcSensorState.pwdUnlockReady ||
        s == NfcSensorState.wifiReady;
  }

  Color _resolveAccent(NfcViewModel vm) {
    final state = vm.sensorState;
    if (state == NfcSensorState.error) {
      return AppColors.danger;
    }
    if (state == NfcSensorState.success) {
      if (vm.successDetail == 'WRITE_WIFI' ||
          vm.operation == NfcOperation.writeWifi) {
        return AppColors.amberWifi;
      }
      if (vm.successDetail == 'PWD_LOCK') {
        return AppColors.pinkLock;
      }
      return AppColors.success;
    }
    switch (vm.visualTheme) {
      case NfcVisualTheme.wifi:
        return AppColors.amberWifi;
      case NfcVisualTheme.lock:
        return AppColors.pinkLock;
      case NfcVisualTheme.permLock:
        return (vm.isPermLockStandby || vm.isEraseStandby)
            ? AppColors.pinkLock
            : AppColors.danger;
      case NfcVisualTheme.unlock:
        return AppColors.success;
      case NfcVisualTheme.link:
        return AppColors.primary;
    }
  }

  Gradient _resolveEmblemGradient(NfcViewModel vm) {
    final state = vm.sensorState;
    if (state == NfcSensorState.error) {
      return AppColors.dangerPermGradient;
    }
    if (state == NfcSensorState.success) {
      if (vm.successDetail == 'WRITE_WIFI' ||
          vm.operation == NfcOperation.writeWifi) {
        return AppColors.wifiAmberGradient;
      }
      if (vm.successDetail == 'PWD_LOCK') {
        return AppColors.pinkLockGradient;
      }
      return AppColors.emeraldUnlockGradient;
    }
    switch (vm.visualTheme) {
      case NfcVisualTheme.wifi:
        return AppColors.wifiAmberGradient;
      case NfcVisualTheme.lock:
        return AppColors.pinkLockGradient;
      case NfcVisualTheme.permLock:
        return (vm.isPermLockStandby || vm.isEraseStandby)
            ? AppColors.pinkLockGradient
            : AppColors.dangerPermGradient;
      case NfcVisualTheme.unlock:
        return AppColors.emeraldUnlockGradient;
      case NfcVisualTheme.link:
        return AppColors.primaryGradient;
    }
  }

  Widget _resolveCenterIcon(NfcViewModel vm) {
    final state = vm.sensorState;
    if (state == NfcSensorState.error) {
      return AppSvgIcons.closeX(size: 32, color: Colors.white);
    }
    if (state == NfcSensorState.success) {
      final isWifi = vm.successDetail == 'WRITE_WIFI' ||
          vm.operation == NfcOperation.writeWifi;
      return AppSvgIcons.checkmark(
        size: 34,
        color: isWifi ? Colors.white : Colors.white,
      );
    }
    switch (state) {
      case NfcSensorState.readReady:
        return AppSvgIcons.readScanner(size: 32, color: Colors.white);
      case NfcSensorState.permLockReady:
      case NfcSensorState.permLockStandby:
        return AppSvgIcons.shieldPermLock(size: 32, color: Colors.white);
      case NfcSensorState.eraseReady:
      case NfcSensorState.eraseStandby:
        return AppSvgIcons.trash(size: 32, color: Colors.white);
      case NfcSensorState.pwdLockReady:
        return AppSvgIcons.lockClosed(size: 30, color: Colors.white);
      case NfcSensorState.pwdUnlockReady:
        return AppSvgIcons.lockOpen(size: 30, color: Colors.white);
      case NfcSensorState.wifiReady:
        return AppSvgIcons.wifiWaves(
          size: 30,
          color: const Color(0xFF140F0A),
        );
      case NfcSensorState.ready:
      case NfcSensorState.success:
      case NfcSensorState.error:
        return AppSvgIcons.nfcSensorWaves(size: 34, color: Colors.white);
    }
  }

  String _resolveTitle(NfcViewModel vm, AppLocalizations l10n) {
    final s = vm.sensorState;
    switch (s) {
      case NfcSensorState.ready:
        return vm.writeBatchCount > 0 ? l10n.nfcTitleNext : l10n.nfcTitleReady;
      case NfcSensorState.readReady:
        return l10n.nfcTitleReadReady;
      case NfcSensorState.permLockReady:
        return l10n.nfcTitlePermLockReady;
      case NfcSensorState.permLockStandby:
        return l10n.nfcTitlePermLockStandby;
      case NfcSensorState.eraseReady:
        return l10n.nfcTitleEraseReady;
      case NfcSensorState.eraseStandby:
        return l10n.nfcTitleEraseSuccess;
      case NfcSensorState.pwdLockReady:
        return vm.writeBatchCount > 0
            ? l10n.nfcTitleNext
            : l10n.nfcTitlePwdLockReady;
      case NfcSensorState.pwdUnlockReady:
        return vm.writeBatchCount > 0
            ? l10n.nfcTitleNext
            : l10n.nfcTitlePwdUnlockReady;
      case NfcSensorState.wifiReady:
        if (vm.writeBatchCount > 0) return l10n.nfcTitleNext;
        return vm.isWifiCloneMode
            ? l10n.nfcTitleWifiClone
            : l10n.nfcTitleWifiReady;
      case NfcSensorState.success:
        if (vm.successDetail == 'PWD_LOCK') return l10n.nfcTitlePwdLockSuccess;
        if (vm.successDetail == 'ALREADY_UNLOCKED') {
          return l10n.nfcTitleAlreadyUnlocked;
        }
        if (vm.successDetail == 'PWD_UNLOCK') {
          return l10n.nfcTitlePwdUnlockSuccess;
        }
        if (vm.successDetail == 'PERM_LOCK') {
          return l10n.nfcTitlePermLockSuccess;
        }
        if (vm.successDetail == 'WRITE_WIFI' ||
            vm.operation == NfcOperation.writeWifi) {
          return vm.isWifiCloneMode
              ? l10n.nfcTitleWifiCloneSuccess
              : l10n.nfcTitleWifiSuccess;
        }
        return l10n.nfcTitleSuccess;
      case NfcSensorState.error:
        switch (vm.errorCode) {
          case 'DISABLED':
            return l10n.nfcTitleDisabled;
          case 'NO_HARDWARE':
          case 'NOT_SUPPORTED':
            return l10n.nfcTitleNoHardware;
          case 'TAG_LOST':
            return l10n.nfcTitleTagLost;
          case 'LOCKED':
            return l10n.nfcTitleLocked;
          case 'READ_LOCKED':
            return l10n.nfcTitleReadLocked;
          case 'WRONG_PWD':
            return l10n.nfcTitleWrongPwd;
          case 'ALREADY_LOCKED':
            return l10n.nfcTitleAlreadyLocked;
          case 'CANNOT_LOCK':
            return l10n.nfcTitleCannotLock;
          case 'CAPACITY':
            return l10n.nfcTitleCapacity;
          case 'EMPTY_TAG':
            return l10n.nfcTitleEmptyTag;
          default:
            return vm.operation == NfcOperation.writeUrl
                ? l10n.nfcTitleError
                : l10n.nfcTitleOpFailed;
        }
    }
  }

  String _resolveDescription(NfcViewModel vm, AppLocalizations l10n) {
    final s = vm.sensorState;
    switch (s) {
      case NfcSensorState.ready:
        return vm.writeBatchCount > 0 ? l10n.nfcDescNext : l10n.nfcDescReady;
      case NfcSensorState.readReady:
        return l10n.nfcDescReadReady;
      case NfcSensorState.permLockReady:
        return l10n.nfcDescPermLockReady;
      case NfcSensorState.permLockStandby:
        return l10n.nfcDescPermLockStandby;
      case NfcSensorState.eraseReady:
        return l10n.nfcDescEraseReady;
      case NfcSensorState.eraseStandby:
        return l10n.nfcDescEraseSuccess;
      case NfcSensorState.pwdLockReady:
        return vm.writeBatchCount > 0
            ? l10n.nfcDescNext
            : l10n.nfcDescPwdLockReady;
      case NfcSensorState.pwdUnlockReady:
        return vm.writeBatchCount > 0
            ? l10n.nfcDescNext
            : l10n.nfcDescPwdUnlockReady;
      case NfcSensorState.wifiReady:
        if (vm.writeBatchCount > 0) return l10n.nfcDescNext;
        final ssid = vm.pendingWifiSsid;
        if (ssid.isNotEmpty) {
          return vm.isWifiCloneMode
              ? l10n.nfcDescWifiCloneWithSsid(ssid)
              : l10n.nfcDescWifiReadyWithSsid(ssid);
        }
        return l10n.nfcDescWifiReady;
      case NfcSensorState.success:
        if (vm.successDetail == 'PWD_LOCK') return l10n.nfcDescPwdLockSuccess;
        if (vm.successDetail == 'ALREADY_UNLOCKED') {
          return l10n.nfcDescAlreadyUnlocked;
        }
        if (vm.successDetail == 'PWD_UNLOCK') {
          return l10n.nfcDescPwdUnlockSuccess;
        }
        if (vm.successDetail == 'PERM_LOCK') {
          return l10n.nfcDescPermLockSuccess;
        }
        if (vm.successDetail == 'WRITE_WIFI' ||
            vm.operation == NfcOperation.writeWifi) {
          return l10n.nfcDescWifiSuccess;
        }
        return l10n.nfcDescSuccess;
      case NfcSensorState.error:
        switch (vm.errorCode) {
          case 'DISABLED':
            return l10n.nfcDisabled;
          case 'NO_HARDWARE':
          case 'NOT_SUPPORTED':
            return l10n.nfcNoHardware;
          case 'TAG_LOST':
            return l10n.nfcDescTagLost;
          case 'LOCKED':
            return l10n.nfcDescLocked;
          case 'READ_LOCKED':
            return l10n.nfcDescReadLocked;
          case 'CANNOT_LOCK':
          case 'LOCK_FAILED':
            return l10n.nfcDescCannotLock;
          case 'CAPACITY':
            return l10n.nfcDescCapacity;
          case 'UNSUPPORTED':
            return l10n.nfcDescUnsupported;
          case 'EMPTY_TAG':
            return l10n.toastNfcReadEmpty;
          case 'WRONG_PWD':
            return l10n.toastNfcWrongPwd;
          case 'PWD_UNSUPPORTED':
            return l10n.toastNfcPwdUnsupported;
          case 'ALREADY_LOCKED':
            return l10n.toastNfcAlreadyLocked;
          case 'MISSING_PIN':
            return l10n.toastEnterPwd;
          default:
            return vm.operation == NfcOperation.writeUrl
                ? l10n.nfcDescGenericError
                : l10n.nfcDescOpFailed;
        }
    }
  }

  String _resolveCancelButtonLabel(NfcViewModel vm, AppLocalizations l10n) {
    if (vm.isCancelButtonActingAsBack) {
      return vm.operation == NfcOperation.writeWifi
          ? l10n.wifiBack
          : l10n.nfcBackToPin;
    }
    if (vm.sensorState == NfcSensorState.success ||
        vm.sensorState == NfcSensorState.permLockStandby ||
        vm.sensorState == NfcSensorState.eraseStandby ||
        vm.writeBatchCount > 0 ||
        (vm.operation == NfcOperation.permLock && vm.permLockBatchCount > 0) ||
        (vm.operation == NfcOperation.erase && vm.eraseBatchCount > 0)) {
      return l10n.nfcDone;
    }
    return l10n.nfcCancel;
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final l10n = AppLocalizations.of(context)!;
    final accent = _resolveAccent(vm);
    final isScanning = _isScanningState(vm.sensorState);

    final showPermBadge =
        vm.operation == NfcOperation.permLock && vm.permLockBatchCount > 0;
    final showEraseBadge =
        vm.operation == NfcOperation.erase && vm.eraseBatchCount > 0;
    final showWriteBadge = vm.operation != NfcOperation.permLock &&
        vm.operation != NfcOperation.erase &&
        vm.writeBatchCount > 0 &&
        vm.sensorState != NfcSensorState.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
          // Animated Sensor Wave Emblem
          TweenAnimationBuilder<double>(
            key: ValueKey<int>(vm.permLockThumpTick),
            tween: Tween<double>(
              begin: vm.permLockThumpTick > 0 ? 1.12 : 1.0,
              end: 1.0,
            ),
            duration: const Duration(milliseconds: 420),
            curve: Curves.elasticOut,
            builder: (context, scaleVal, child) => Transform.scale(
              scale: scaleVal,
              child: child,
            ),
            child: SizedBox(
              width: 146,
              height: 146,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: vm.isPermLockStandby
                    ? vm.rearmSequentialPermLock
                    : (vm.isEraseStandby ? vm.rearmSequentialErase : null),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (BuildContext context, Widget? centerChild) {
                    final t1 = _pulseController.value;
                    final t2 = (_pulseController.value + 0.5) % 1.0;

                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        if (isScanning) ...<Widget>[
                          _buildPulseRing(t1, accent),
                          _buildPulseRing(t2, accent),
                        ] else ...<Widget>[
                          Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accent.withValues(alpha: 0.14),
                                width: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accent.withValues(alpha: 0.25),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ],
                        centerChild!,
                      ],
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _resolveEmblemGradient(vm),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: accent.withValues(alpha: 0.42),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (c, a) => ScaleTransition(
                          scale: a,
                          child: FadeTransition(opacity: a, child: c),
                        ),
                        child: KeyedSubtree(
                          key: ValueKey<String>(
                            '${vm.sensorState.name}_${vm.successDetail ?? ""}',
                          ),
                          child: _resolveCenterIcon(vm),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Batch Counter Pill Badge
          if (showPermBadge || showEraseBadge || showWriteBadge) ...<Widget>[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: accent.withValues(alpha: 0.36),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    showPermBadge
                        ? l10n.nfcPermLockCount(vm.permLockBatchCount)
                        : (showEraseBadge
                            ? l10n.nfcEraseCount(vm.eraseBatchCount)
                            : l10n.nfcCardsCount(vm.writeBatchCount)),
                    style: TextStyle(
                      color: accent == AppColors.amberWifi
                          ? AppColors.amberWifiLight
                          : AppColors.textPrimary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Modal Title
          Text(
            _resolveTitle(vm, l10n),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.28,
            ),
          ),
          const SizedBox(height: 8),

          // Modal Description
          Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.center,
            child: Text(
              _resolveDescription(vm, l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Action Buttons Area
          _buildActionButtons(context, vm, l10n),
        ],
      );
    }

  Widget _buildPulseRing(double progress, Color color) {
    final size = 82.0 + (62.0 * progress);
    final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.45;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: opacity),
          width: 1.8,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    NfcViewModel vm,
    AppLocalizations l10n,
  ) {
    final cancelLabel = _resolveCancelButtonLabel(vm, l10n);

    // 1. Wi-Fi Write Success: 2+1 Layout ([Write Another] + [QR Code] on top, full-width [Done] below)
    final isWifiSuccess = vm.sensorState == NfcSensorState.success &&
        (vm.successDetail == 'WRITE_WIFI' ||
            vm.operation == NfcOperation.writeWifi);

    if (isWifiSuccess) {
      final anotherLabel = vm.isWifiCloneMode
          ? l10n.nfcBtnWifiCloneAnother
          : l10n.nfcBtnWifiAnother;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: PressableScale(
                  key: const Key('btn_wifi_write_another'),
                  onTap: vm.handleNextCardAction,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: AppColors.wifiAmberGradient,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.amberWifi.withValues(alpha: 0.34),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AppSvgIcons.wifiWaves(
                          size: 17,
                          color: const Color(0xFF140F0A),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              anotherLabel,
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
                  key: const Key('btn_wifi_success_qr'),
                  onTap: () {
                    final creds = vm.resolveEffectiveWifiCredentials();
                    showWifiQrCodeModal(
                      context: context,
                      credentials: creds,
                      hardwareBridge: widget.hardwareBridge,
                      onShowToast: widget.onShowToast,
                    );
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.amberWifi.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.amberWifi.withValues(alpha: 0.42),
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
            key: const Key('btn_wifi_success_done'),
            onTap: () async {
              final handledInternally = await vm.handleCancelOrBack();
              if (!handledInternally) {
                widget.onRequestCloseModal();
              }
            },
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.subtleButtonBg,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.borderGlass),
              ),
              alignment: Alignment.center,
              child: Text(
                cancelLabel,
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 2. Erase Standby (Success) State
    if (vm.isEraseStandby) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: PressableScale(
              key: const Key('btn_erase_another'),
              onTap: vm.rearmSequentialErase,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.pinkLockGradient,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.pinkLock.withValues(alpha: 0.34),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppSvgIcons.trash(size: 17, color: Colors.white),
                    const SizedBox(width: 7),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.nfcBtnEraseAnother,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
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
            child: _buildCancelBtn(vm, cancelLabel),
          ),
        ],
      );
    }

    // 3. Other Success States (URL Write / PIN Lock / PIN Unlock)
    if (vm.sensorState == NfcSensorState.success &&
        vm.successDetail != 'PERM_LOCK') {
      final isPinSuccess = vm.operation == NfcOperation.pwdLock ||
          vm.operation == NfcOperation.pwdUnlock ||
          vm.successDetail == 'PWD_LOCK' ||
          vm.successDetail == 'PWD_UNLOCK' ||
          vm.successDetail == 'ALREADY_UNLOCKED';

      if (isPinSuccess) {
        String nextLabel = l10n.nfcBtnLockAnother;
        Gradient nextGrad = AppColors.pinkLockGradient;
        Widget nextIcon = AppSvgIcons.lockClosed(size: 17, color: Colors.white);
        Color shadowColor = AppColors.pinkLock;

        if (vm.successDetail == 'PWD_UNLOCK' ||
            vm.successDetail == 'ALREADY_UNLOCKED' ||
            vm.operation == NfcOperation.pwdUnlock) {
          nextLabel = l10n.nfcBtnUnlockAnother;
          nextGrad = AppColors.emeraldUnlockGradient;
          nextIcon = AppSvgIcons.lockOpen(size: 17, color: Colors.white);
          shadowColor = AppColors.success;
        }

        return Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: PressableScale(
                key: const Key('btn_pin_success_another'),
                onTap: vm.handleNextCardAction,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: nextGrad,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: shadowColor.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      nextIcon,
                      const SizedBox(width: 7),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            nextLabel,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
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
              child: _buildCancelBtn(vm, cancelLabel),
            ),
          ],
        );
      }

      // Default URL Write success
      return Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: PressableScale(
              key: const Key('btn_write_another'),
              onTap: vm.handleNextCardAction,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppSvgIcons.nfcSensorWaves(size: 17, color: Colors.white),
                    const SizedBox(width: 7),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.nfcBtnWriteAnother,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
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
            child: _buildCancelBtn(vm, cancelLabel),
          ),
        ],
      );
    }

    // 4. Error State with Retry Button (unless NO_HARDWARE)
    if (vm.sensorState == NfcSensorState.error &&
        vm.errorCode != 'NO_HARDWARE' &&
        vm.errorCode != 'NOT_SUPPORTED') {
      const retryGrad = AppColors.dangerPermGradient;
      const shadowColor = AppColors.danger;

      return Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: PressableScale(
              key: const Key('btn_nfc_retry'),
              onTap: vm.handleRetryAction,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  gradient: retryGrad,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: shadowColor.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppSvgIcons.retryRefresh(size: 17, color: Colors.white),
                    const SizedBox(width: 7),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.nfcRetryBtn,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
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
            child: _buildCancelBtn(vm, cancelLabel),
          ),
        ],
      );
    }

    // 4. Wi-Fi Clone Ready Mode (shows QR Code alongside Back)
    if (vm.sensorState == NfcSensorState.wifiReady &&
        vm.isWifiCloneMode &&
        vm.writeBatchCount == 0) {
      return Row(
        children: <Widget>[
          Expanded(
            child: PressableScale(
              onTap: () {
                final creds = vm.resolveEffectiveWifiCredentials();
                showWifiQrCodeModal(
                  context: context,
                  credentials: creds,
                  hardwareBridge: widget.hardwareBridge,
                  onShowToast: widget.onShowToast,
                );
              },
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.amberWifi.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.amberWifi.withValues(alpha: 0.42),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppSvgIcons.qrGrid(
                      size: 16,
                      color: AppColors.amberWifiLight,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      l10n.wifiQrBtn,
                      style: TextStyle(
                        color: AppColors.amberWifiLight,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _buildCancelBtn(vm, cancelLabel)),
        ],
      );
    }

    // 5. Default Single Cancel / Done / Back Button
    return _buildCancelBtn(vm, cancelLabel);
  }

  Widget _buildCancelBtn(NfcViewModel vm, String label) {
    return PressableScale(
      key: const Key('btn_nfc_cancel'),
      onTap: () async {
        final handledInternally = await vm.handleCancelOrBack();
        if (!handledInternally) {
          widget.onRequestCloseModal();
        }
      },
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.subtleButtonBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.borderGlass),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
        ),
      ),
    );
  }
}
