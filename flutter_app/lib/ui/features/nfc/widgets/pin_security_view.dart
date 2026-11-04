import 'package:flutter/material.dart';

import '../../../../domain/models/nfc_models.dart';
import '../../../../domain/models/toast_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lang_roll_text.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/sliding_segmented_control.dart';
import '../view_models/nfc_view_model.dart';

class PinSecurityView extends StatefulWidget {
  const PinSecurityView({
    super.key,
    required this.viewModel,
    required this.onShowToast,
    required this.onRequestCloseModal,
  });

  final NfcViewModel viewModel;
  final void Function(String message, {ToastType type}) onShowToast;
  final VoidCallback onRequestCloseModal;

  @override
  State<PinSecurityView> createState() => _PinSecurityViewState();
}

class _PinSecurityViewState extends State<PinSecurityView> {
  bool _obscurePin = true;

  Future<void> _submit(AppLocalizations l10n) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final ok = await widget.viewModel.submitPinForm();
    if (!ok) {
      widget.onShowToast(l10n.toastEnterPwd, type: ToastType.warn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final l10n = AppLocalizations.of(context)!;
    final isLock = vm.pinMode == PinMode.lock;
    final accent = isLock ? AppColors.pinkLock : AppColors.success;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Morphing Lock / Unlock Emblem
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isLock
                ? AppColors.pinkLockGradient
                : AppColors.emeraldUnlockGradient,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: accent.withValues(alpha: 0.38),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: Tween<double>(begin: 0.92, end: 1.0).animate(anim),
                child: ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey<PinMode>(vm.pinMode),
                child: isLock
                    ? AppSvgIcons.lockClosed(size: 28, color: Colors.white)
                    : AppSvgIcons.lockOpen(size: 28, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Title & Subtitle
        LangRollText(
          isLock ? l10n.pwdModalTitleLock : l10n.pwdModalTitleUnlock,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        LangRollText(
          isLock ? l10n.pwdModalDescLock : l10n.pwdModalDescUnlock,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSub,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),

        // Lock / Unlock Segmented Switcher
        SlidingSegmentedControl(
          selectedIndex: isLock ? 0 : 1,
          onChanged: (idx) =>
              vm.setPinMode(idx == 0 ? PinMode.lock : PinMode.unlock),
          pillGradient: isLock
              ? LinearGradient(
                  colors: <Color>[
                    AppColors.pinkLock
                        .withValues(alpha: AppColors.isLight ? 0.88 : 0.34),
                    AppColors.pinkLockDark
                        .withValues(alpha: AppColors.isLight ? 0.88 : 0.28),
                  ],
                )
              : LinearGradient(
                  colors: <Color>[
                    AppColors.success
                        .withValues(alpha: AppColors.isLight ? 0.88 : 0.34),
                    AppColors.successDark
                        .withValues(alpha: AppColors.isLight ? 0.88 : 0.28),
                  ],
                ),
          pillBorderColor: accent.withValues(alpha: 0.55),
          pillShadowColor: accent.withValues(alpha: 0.25),
          items: <SegmentedTabItem>[
            SegmentedTabItem(
              semanticKey: const Key('tab_pin_lock'),
              label: l10n.pwdTabLock,
            ),
            SegmentedTabItem(
              semanticKey: const Key('tab_pin_unlock'),
              label: l10n.pwdTabUnlock,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // PIN Input Field
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accent.withValues(alpha: 0.34),
              width: 1,
            ),
          ),
          child: TextField(
            key: const Key('input_nfc_pin'),
            controller: vm.pinController,
            obscureText: _obscurePin,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            onSubmitted: (_) => _submit(l10n),
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
            decoration: InputDecoration(
              hintText: l10n.pwdPlaceholder,
              hintStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                color: AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    key: const Key('btn_pin_info'),
                    tooltip: l10n.pwdHintText,
                    onPressed: () => widget.onShowToast(l10n.pwdInfoToast),
                    splashRadius: 18,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                    icon: AppSvgIcons.infoCircle(
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                  IconButton(
                    key: const Key('btn_pin_toggle_obscure'),
                    onPressed: () => setState(() => _obscurePin = !_obscurePin),
                    splashRadius: 18,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 34,
                      minHeight: 34,
                    ),
                    icon: _obscurePin
                        ? AppSvgIcons.eyeOpen(size: 19, color: AppColors.textSub)
                        : AppSvgIcons.eyeClosed(size: 19, color: accent),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Buttons Row: Submit & Cancel side-by-side
        Row(
          children: <Widget>[
            // Submit Button
            Expanded(
              flex: 6,
              child: PressableScale(
                key: const Key('btn_pin_submit'),
                onTap: () => _submit(l10n),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isLock
                        ? AppColors.pinkLockGradient
                        : AppColors.emeraldUnlockGradient,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isLock ? l10n.pwdSubmitLock : l10n.pwdSubmitUnlock,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Cancel Button
            Expanded(
              flex: 4,
              child: PressableScale(
                key: const Key('btn_pin_cancel'),
                onTap: () async {
                  await vm.closeAndResetSession();
                  widget.onRequestCloseModal();
                },
                child: Container(
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
                      l10n.pwdCancel,
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
