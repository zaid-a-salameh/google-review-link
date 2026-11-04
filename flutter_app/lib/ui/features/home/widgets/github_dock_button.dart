import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lang_roll_text.dart';
import '../../../core/widgets/pressable_scale.dart';

class GithubDockButton extends StatelessWidget {
  const GithubDockButton({
    super.key,
    required this.onTapProject,
    required this.onTapSupport,
  });

  final VoidCallback onTapProject;
  final VoidCallback onTapSupport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: <Widget>[
        Expanded(
          child: PressableScale(
            key: const Key('btn_github_project'),
            onTap: onTapProject,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.dockButtonBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppSvgIcons.githubOctocat(
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: LangRollText(
                      l10n.githubProjectBtn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AppSvgIcons.openExternal(size: 13, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PressableScale(
            key: const Key('btn_github_support'),
            onTap: onTapSupport,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.dockButtonBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.pinkLock.withValues(alpha: 0.24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppSvgIcons.heartSponsor(size: 17, color: AppColors.pinkLock),
                  const SizedBox(width: 8),
                  Flexible(
                    child: LangRollText(
                      l10n.githubSupportBtn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
