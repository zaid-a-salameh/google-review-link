import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../view_models/nfc_view_model.dart';

class EraseConfirmView extends StatelessWidget {
  const EraseConfirmView({
    super.key,
    required this.viewModel,
    required this.onRequestCloseModal,
  });

  final NfcViewModel viewModel;
  final VoidCallback onRequestCloseModal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Emblem Icon (Rose-red Danger Gradient)
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.dangerPermGradient,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.danger.withValues(alpha: 0.38),
                blurRadius: 22,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: AppSvgIcons.trash(size: 28, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          l10n.eraseModalTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        // Warning Callout Box
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.danger.withValues(alpha: 0.32),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AppSvgIcons.warningTriangle(
                  size: 19,
                  color: AppColors.dangerLight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.eraseModalDesc,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13.2,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Side-by-side Confirm & Cancel Buttons
        Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: PressableScale(
                key: const Key('btn_erase_confirm'),
                onTap: viewModel.confirmAndStartErase,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.dangerPermGradient,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.danger.withValues(alpha: 0.36),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.eraseConfirmBtn,
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
            Expanded(
              flex: 4,
              child: PressableScale(
                key: const Key('btn_erase_cancel'),
                onTap: () async {
                  await viewModel.closeAndResetSession();
                  onRequestCloseModal();
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
                      l10n.eraseCancelBtn,
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
