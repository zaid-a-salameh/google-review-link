import 'package:flutter/material.dart';

import '../../../../domain/models/link_mode_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/lang_roll_text.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/sliding_segmented_control.dart';
import '../view_models/home_view_model.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.viewModel,
    required this.onWriteNfc,
    required this.onOpenQr,
  });

  final HomeViewModel viewModel;
  final VoidCallback onWriteNfc;
  final VoidCallback onOpenQr;

  @override
  Widget build(BuildContext context) {
    final res = viewModel.currentResult;
    final activeUrl = res.activeUrl;
    if (!res.isResultActive || activeUrl == null || activeUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final isLocationSelected = res.activeType == LinkOutputType.location;
    final headerColor = isLocationSelected
        ? AppColors.skyLocationLight
        : AppColors.primaryLight;

    return GlassCard(
      key: const Key('result_card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1. Result Header Row
          Row(
            children: <Widget>[
              AppSvgIcons.checkmark(size: 16, color: headerColor),
              const SizedBox(width: 7),
              Expanded(
                child: LangRollText(
                  viewModel.resultHeaderLabel(l10n),
                  style: TextStyle(
                    color: headerColor,
                    fontSize: 13.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Smooth Animated-Height Monospace URL Box (Zero Layout Jump)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.urlBoxBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 190),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        ...previousChildren,
                        ?currentChild,
                      ],
                    );
                  },
                  child: SelectableText(
                    activeUrl,
                    key: ValueKey<String>('${activeUrl}_${AppColors.isLight}'),
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      color: AppColors.textPrimary,
                      fontSize: 13.4,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Unified Icon-Free Link Type Switcher (5-Star Review | Map Location)
          if (res.canSwitchLinkType) ...<Widget>[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
              decoration: BoxDecoration(
                color: AppColors.isLight
                    ? const Color(0x0A000000)
                    : const Color(0x06FFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LangRollText(
                      l10n.linkTypePrompt,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlidingSegmentedControl(
                    key: const Key('segmented_link_type'),
                    height: 46,
                    selectedIndex: isLocationSelected ? 1 : 0,
                    onChanged: (idx) => viewModel.setLinkType(
                      idx == 0
                          ? LinkOutputType.review
                          : LinkOutputType.location,
                    ),
                    pillGradient: isLocationSelected
                        ? AppColors.locationPillGradient
                        : AppColors.reviewPillGradient,
                    pillBorderColor: isLocationSelected
                        ? AppColors.skyLocationLight.withValues(alpha: 0.65)
                        : AppColors.primaryLight.withValues(alpha: 0.65),
                    pillShadowColor: isLocationSelected
                        ? AppColors.skyLocation.withValues(alpha: 0.30)
                        : AppColors.primary.withValues(alpha: 0.30),
                    items: <SegmentedTabItem>[
                      SegmentedTabItem(
                        semanticKey: const Key('btn_type_review'),
                        label: l10n.linkTypeReview,
                      ),
                      SegmentedTabItem(
                        semanticKey: const Key('btn_type_location'),
                        label: l10n.linkTypeLocation,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // 4. Write to NFC Tag Primary Gradient Button
          PressableScale(
            key: const Key('btn_write_nfc'),
            onTap: onWriteNfc,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.nfcWriteButtonGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.62),
                  width: 1.2,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.26),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppSvgIcons.nfcTagSquare(size: 19, color: Colors.white),
                  const SizedBox(width: 9),
                  LangRollText(
                    l10n.nfcBtn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 5. Open Link
          _SecondaryActionBtn(
            btnKey: const Key('btn_open_link'),
            icon: AppSvgIcons.openExternal(
              size: 18,
              color: AppColors.textPrimary,
            ),
            label: l10n.openBtn,
            onTap: viewModel.openActiveLink,
          ),
          const SizedBox(height: 10),

          // 6. Copy Link
          _SecondaryActionBtn(
            btnKey: const Key('btn_copy_link'),
            icon: viewModel.isCopiedFeedback
                ? AppSvgIcons.checkmark(size: 18, color: AppColors.successLight)
                : AppSvgIcons.copyIcon(
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
            label: viewModel.isCopiedFeedback ? l10n.copySuccess : l10n.copyBtn,
            highlightSuccess: viewModel.isCopiedFeedback,
            onTap: () => viewModel.copyActiveLink(l10n),
          ),
          const SizedBox(height: 10),

          // 7. Share Link
          _SecondaryActionBtn(
            btnKey: const Key('btn_share_link'),
            icon: AppSvgIcons.shareNodes(
              size: 18,
              color: AppColors.textPrimary,
            ),
            label: l10n.shareBtn,
            onTap: () => viewModel.shareActiveLink(l10n),
          ),
          const SizedBox(height: 10),

          // 8. Generate QR Code
          _SecondaryActionBtn(
            btnKey: const Key('btn_generate_qr'),
            icon: AppSvgIcons.qrGrid(size: 18, color: AppColors.textPrimary),
            label: l10n.qrBtn,
            onTap: onOpenQr,
          ),
        ],
      ),
    );
  }
}

class _SecondaryActionBtn extends StatelessWidget {
  const _SecondaryActionBtn({
    required this.btnKey,
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlightSuccess = false,
  });

  final Key btnKey;
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final bool highlightSuccess;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      key: btnKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        decoration: BoxDecoration(
          color: highlightSuccess
              ? AppColors.success.withValues(alpha: 0.14)
              : AppColors.secondaryBtnBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlightSuccess
                ? AppColors.success.withValues(alpha: 0.50)
                : AppColors.borderGlass,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 9),
            LangRollText(
              label,
              style: TextStyle(
                color: highlightSuccess
                    ? AppColors.successLight
                    : AppColors.textPrimary,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
