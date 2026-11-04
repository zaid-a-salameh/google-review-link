import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/lang_roll_text.dart';
import '../../../core/widgets/pressable_scale.dart';

class CardToolsGrid extends StatelessWidget {
  const CardToolsGrid({
    super.key,
    required this.onReadCard,
    required this.onOpenWifiWizard,
    required this.onOpenPinSecurity,
    required this.onOpenErase,
    required this.onOpenPermLock,
  });

  final VoidCallback onReadCard;
  final VoidCallback onOpenWifiWizard;
  final VoidCallback onOpenPinSecurity;
  final VoidCallback onOpenErase;
  final VoidCallback onOpenPermLock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final neutralTileBg = AppColors.isLight
        ? const Color(0xFFF3F1ED)
        : const Color(0x80120F0E);
    final wifiTileBg = AppColors.isLight
        ? const Color(0xFFFEF7EA)
        : const Color(0x8015110D);
    final dangerTileBg = AppColors.isLight
        ? const Color(0xFFFDF0F3)
        : const Color(0x80170E12);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _ToolTile(
                  tileKey: const Key('btn_tool_read_card'),
                  icon: AppSvgIcons.readScanner(
                    size: 22,
                    color: AppColors.primaryLight,
                  ),
                  label: l10n.lblReadTag,
                  borderColor: AppColors.borderGlass,
                  backgroundColor: neutralTileBg,
                  onTap: onReadCard,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ToolTile(
                  tileKey: const Key('btn_tool_wifi_card'),
                  icon: AppSvgIcons.wifiWaves(
                    size: 21,
                    color: AppColors.amberWifiLight,
                  ),
                  label: l10n.lblWifiTag,
                  borderColor: AppColors.amberWifi.withValues(alpha: 0.24),
                  backgroundColor: wifiTileBg,
                  onTap: onOpenWifiWizard,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _ToolTile(
                  tileKey: const Key('btn_tool_pin_lock'),
                  icon: AppSvgIcons.lockClosed(
                    size: 20,
                    color: AppColors.primaryLight,
                  ),
                  label: l10n.lblPwdLockTag,
                  borderColor: AppColors.borderGlass,
                  backgroundColor: neutralTileBg,
                  fontSize: 11.8,
                  onTap: onOpenPinSecurity,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ToolTile(
                  tileKey: const Key('btn_tool_erase_card'),
                  icon: AppSvgIcons.trash(
                    size: 20,
                    color: AppColors.pinkLock,
                  ),
                  label: l10n.lblEraseTag,
                  borderColor: AppColors.pinkLock.withValues(alpha: 0.26),
                  backgroundColor: dangerTileBg,
                  fontSize: 11.8,
                  onTap: onOpenErase,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ToolTile(
                  tileKey: const Key('btn_tool_perm_lock'),
                  icon: AppSvgIcons.shieldPermLock(
                    size: 20,
                    color: AppColors.pinkLock,
                  ),
                  label: l10n.lblPermLockTag,
                  borderColor: AppColors.pinkLock.withValues(alpha: 0.26),
                  backgroundColor: dangerTileBg,
                  fontSize: 11.8,
                  onTap: onOpenPermLock,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.tileKey,
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.backgroundColor,
    required this.onTap,
    this.fontSize = 12.5,
  });

  final Key tileKey;
  final Widget icon;
  final String label;
  final Color borderColor;
  final Color backgroundColor;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      key: tileKey,
      onTap: onTap,
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: LangRollText(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
