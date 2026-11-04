import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pressable_scale.dart';
import 'version_update_pill.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({
    super.key,
    required this.onOpenGuide,
    required this.onOpenSettings,
    required this.onCheckUpdate,
    required this.currentVersion,
    this.hasUpdate = false,
    this.isCheckingUpdate = false,
  });

  final VoidCallback onOpenGuide;
  final VoidCallback onOpenSettings;
  final VoidCallback onCheckUpdate;
  final String currentVersion;
  final bool hasUpdate;
  final bool isCheckingUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // App Version & Update Status Pill (Top Left)
            VersionUpdatePill(
              key: const Key('btn_check_update'),
              version: currentVersion,
              hasUpdate: hasUpdate,
              isChecking: isCheckingUpdate,
              isArabic: isArabic,
              onTap: onCheckUpdate,
            ),

            // Top Right Action Buttons (Guide & Settings)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Help / User Guide Icon Button
                PressableScale(
                  key: const Key('btn_open_guide'),
                  onTap: onOpenGuide,
                  child: Tooltip(
                    message: l10n.btnHelpGuideTitle,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.topBarButtonBg,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Center(
                        child: AppSvgIcons.helpQuestion(
                          size: 19,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Settings Icon Button
                PressableScale(
                  key: const Key('btn_open_settings'),
                  onTap: onOpenSettings,
                  child: Tooltip(
                    message: l10n.settingsTitle,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.topBarButtonBg,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppColors.borderGlass,
                        ),
                      ),
                      child: Center(
                        child: AppSvgIcons.settingsGear(
                          size: 20,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
