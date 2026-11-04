import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pressable_scale.dart';

class VersionUpdatePill extends StatefulWidget {
  const VersionUpdatePill({
    super.key,
    required this.version,
    required this.hasUpdate,
    required this.isChecking,
    required this.isArabic,
    required this.onTap,
  });

  final String version;
  final bool hasUpdate;
  final bool isChecking;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  State<VersionUpdatePill> createState() => _VersionUpdatePillState();
}

class _VersionUpdatePillState extends State<VersionUpdatePill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _glowAnimation = Tween<double>(begin: 0.35, end: 0.90).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.hasUpdate) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VersionUpdatePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasUpdate != oldWidget.hasUpdate) {
      if (widget.hasUpdate) {
        _glowController.repeat(reverse: true);
      } else {
        _glowController.stop();
        _glowController.reset();
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tooltipText = widget.hasUpdate
        ? (widget.isArabic ? 'يوجد تحديث متوفر' : 'Update Available')
        : (widget.isArabic ? 'التحقق من وجود تحديثات' : 'Check for Updates');

    final displayVersion = widget.version.toLowerCase().startsWith('v')
        ? widget.version
        : 'v${widget.version}';

    return PressableScale(
      key: const Key('pressable_version_pill'),
      onTap: widget.onTap,
      child: Tooltip(
        message: tooltipText,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, _) {
            final glowAlpha = widget.hasUpdate ? _glowAnimation.value : 0.0;

            return Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: widget.hasUpdate
                    ? const LinearGradient(
                        colors: <Color>[
                          Color(0x3822C55E),
                          Color(0x5910B981),
                        ],
                      )
                    : null,
                color: widget.hasUpdate ? null : AppColors.topBarButtonBg,
                border: Border.all(
                  color: widget.hasUpdate
                      ? Color.lerp(
                          const Color(0xFF16A34A),
                          const Color(0xFF22C55E),
                          glowAlpha,
                        )!
                      : AppColors.borderGlass,
                  width: widget.hasUpdate ? 1.4 : 1.0,
                ),
                boxShadow: widget.hasUpdate
                    ? <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF22C55E)
                              .withValues(alpha: 0.28 * glowAlpha + 0.15),
                          blurRadius: 14 * glowAlpha + 4,
                          spreadRadius: 1.2 * glowAlpha,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Status dot or checking indicator
                  if (widget.isChecking)
                    SizedBox(
                      width: 11,
                      height: 11,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.6,
                        color: AppColors.primaryLight,
                      ),
                    )
                  else
                    Container(
                      width: 7.5,
                      height: 7.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.hasUpdate
                            ? const Color(0xFF4ADE80)
                            : const Color(0xFF78716C),
                        boxShadow: widget.hasUpdate
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: const Color(0xFF4ADE80)
                                      .withValues(alpha: 0.7 * glowAlpha + 0.3),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  const SizedBox(width: 7),

                  // Version text
                    Text(
                      displayVersion,
                      style: TextStyle(
                        color: widget.hasUpdate
                            ? (AppColors.isLight
                                ? const Color(0xFF065F46)
                                : Colors.white)
                            : AppColors.textSub,
                        fontSize: 12,
                        fontWeight:
                            widget.hasUpdate ? FontWeight.w800 : FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),

                  // "New" or "تحديث" badge when update is available
                  if (widget.hasUpdate) ...<Widget>[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.isArabic ? 'تحديث' : 'New',
                        style: const TextStyle(
                          color: Color(0xFF0C0A09),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
