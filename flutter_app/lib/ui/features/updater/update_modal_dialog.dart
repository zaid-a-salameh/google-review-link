import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/models/app_release_info.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/icons/app_svg_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/morph_dialog.dart';
import '../../core/widgets/pressable_scale.dart';

Future<void> showAppUpdateModal({
  required BuildContext context,
  required AppReleaseInfo release,
  required String currentVersion,
  required VoidCallback onInstall,
  required VoidCallback onDismiss,
}) {
  return showAppMorphDialog<void>(
    context: context,
    builder: (_) => UpdateModalDialog(
      release: release,
      currentVersion: currentVersion,
      onInstall: onInstall,
      onDismiss: onDismiss,
    ),
  );
}

class UpdateModalDialog extends StatelessWidget {
  const UpdateModalDialog({
    super.key,
    required this.release,
    required this.currentVersion,
    required this.onInstall,
    required this.onDismiss,
  });

  final AppReleaseInfo release;
  final String currentVersion;
  final VoidCallback onInstall;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeStr = Localizations.localeOf(context).languageCode;
    final formattedSize = AppReleaseInfo.formatBytes(release.assetSizeBytes);
    final formattedDate = release.publishedAt != null
        ? DateFormat.yMMMd(localeStr).format(release.publishedAt!.toLocal())
        : '';

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic _) {
        if (didPop) onDismiss();
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                decoration: BoxDecoration(
                  gradient: AppColors.modalGradient,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.32),
                    width: 1.1,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.isLight
                          ? const Color(0x28000000)
                          : const Color(0x99000000),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.38),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AppSvgIcons.cloudDownload(
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        l10n.updateAvailable,
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.updateReadyTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _versionChip(
                          label: l10n.updateCurrent,
                          ver: 'v${AppReleaseInfo.normalizeVersion(currentVersion)}',
                          highlight: false,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                        ),
                        _versionChip(
                          label: l10n.updateNew,
                          ver: 'v${release.cleanVersion}',
                          highlight: true,
                        ),
                      ],
                    ),
                    if (formattedSize.isNotEmpty ||
                        formattedDate.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          if (formattedSize.isNotEmpty)
                            Text(
                              l10n.updateSize(formattedSize),
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (formattedDate.isNotEmpty)
                            Text(
                              l10n.updateDate(formattedDate),
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (release.releaseNotes.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 150),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                l10n.updateHighlights,
                                style: TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                release.releaseNotes,
                                style: TextStyle(
                                  color: AppColors.textSub,
                                  fontSize: 12.5,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    PressableScale(
                      onTap: () {
                        Navigator.of(context).maybePop();
                        onInstall();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.updateInstallBtn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: PressableScale(
                            onTap: () async {
                              final uri = Uri.tryParse(release.releasePageUrl);
                              if (uri != null) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.subtleButtonBg,
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: AppColors.borderGlass),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.updateViewGithub,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: PressableScale(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.subtleButtonBg,
                                borderRadius: BorderRadius.circular(14),
                                border:
                                    Border.all(color: AppColors.borderGlass),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                l10n.updateLater,
                                style: TextStyle(
                                  color: AppColors.textSub,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _versionChip({
    required String label,
    required String ver,
    required bool highlight,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.success.withValues(alpha: 0.14)
            : AppColors.subtleButtonBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.borderGlass,
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            ver,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              color: highlight ? AppColors.successLight : AppColors.textSub,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
