import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../core/icons/app_svg_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/morph_dialog.dart';
import '../../core/widgets/pressable_scale.dart';

Future<void> showOnboardingTourModal({
  required BuildContext context,
  required VoidCallback onCompleted,
}) {
  return showAppMorphDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => OnboardingModalDialog(onCompleted: onCompleted),
  );
}

class OnboardingModalDialog extends StatefulWidget {
  const OnboardingModalDialog({
    super.key,
    required this.onCompleted,
  });

  final VoidCallback onCompleted;

  @override
  State<OnboardingModalDialog> createState() => _OnboardingModalDialogState();
}

class _OnboardingModalDialogState extends State<OnboardingModalDialog> {
  int _step = 0;
  int _direction = 1;

  void _goToStep(int target) {
    if (target == _step || target < 0 || target > 2) return;
    setState(() {
      _direction = target > _step ? 1 : -1;
      _step = target;
    });
  }

  void _finishTour() {
    widget.onCompleted();
    Navigator.of(context).maybePop();
  }

  Color _stepAccent(int step) {
    switch (step) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.skyLocation;
      default:
        return AppColors.amberWifi;
    }
  }

  Gradient _stepGradient(int step) {
    switch (step) {
      case 0:
        return AppColors.primaryGradient;
      case 1:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.skyLocationDark, AppColors.skyLocationLight],
        );
      default:
        return AppColors.wifiAmberGradient;
    }
  }

  Widget _stepIcon(int step) {
    switch (step) {
      case 0:
        return AppSvgIcons.linkChain(size: 30, color: Colors.white);
      case 1:
        return AppSvgIcons.searchMagnifier(size: 30, color: Colors.white);
      default:
        return AppSvgIcons.nfcSensorWaves(
          size: 30,
          color: const Color(0xFF140F0A),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final accent = _stepAccent(_step);

    final titles = <String>[
      l10n.obStep1Title,
      l10n.obStep2Title,
      l10n.obStep3Title,
    ];
    final descriptions = <String>[
      l10n.obStep1Desc,
      l10n.obStep2Desc,
      l10n.obStep3Desc,
    ];

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic _) {
        if (didPop) {
          widget.onCompleted();
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
                decoration: BoxDecoration(
                  gradient: AppColors.modalGradient,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.34),
                    width: 1.1,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: accent.withValues(alpha: 0.16),
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
                child: Stack(
                  children: <Widget>[
                    PositionedDirectional(
                      top: 0,
                      end: 0,
                      child: PressableScale(
                        key: const Key('btn_close_onboarding'),
                        onTap: _finishTour,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.subtleButtonBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderGlass),
                          ),
                          child: Center(
                            child: AppSvgIcons.closeX(
                              size: 16,
                              color: AppColors.textSub,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Morphing Top Hero Icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _stepGradient(_step),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: accent.withValues(alpha: 0.42),
                            blurRadius: 22,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: KeyedSubtree(
                            key: ValueKey<int>(_step),
                            child: _stepIcon(_step),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Stepper Dots 1 - 2 - 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildStepCircle(0, accent),
                        _buildStepLine(_step >= 1, accent),
                        _buildStepCircle(1, accent),
                        _buildStepLine(_step >= 2, accent),
                        _buildStepCircle(2, accent),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Directional Slide Content
                    AnimatedSize(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, anim) {
                          final isEntering =
                              child.key == ValueKey<int>(_step);
                          final rtlSign = isRtl ? -1.0 : 1.0;
                          final dx = _direction * rtlSign * 0.18;
                          final beginOffset = isEntering
                              ? Offset(dx, 0)
                              : Offset(-dx, 0);
                          return FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: beginOffset,
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          key: ValueKey<int>(_step),
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              titles[_step],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              descriptions[_step],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSub,
                                fontSize: 13.8,
                                fontWeight: FontWeight.w500,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Next / Get Started Button
                    PressableScale(
                      key: const Key('btn_onboarding_next'),
                      onTap: () {
                        if (_step < 2) {
                          _goToStep(_step + 1);
                        } else {
                          _finishTour();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: _stepGradient(_step),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: accent.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _step < 2 ? l10n.obBtnNext : l10n.obBtnStart,
                          style: TextStyle(
                            color: _step == 2
                                ? const Color(0xFF140F0A)
                                : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    if (_step < 2) ...<Widget>[
                      const SizedBox(height: 10),
                      PressableScale(
                        key: const Key('btn_onboarding_skip'),
                        onTap: _finishTour,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            l10n.obBtnSkip,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildStepCircle(int index, Color activeAccent) {
    final isCurrent = _step == index;
    final isDone = _step > index;

    return GestureDetector(
      onTap: () => _goToStep(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrent
              ? activeAccent
              : (isDone
                  ? activeAccent.withValues(alpha: 0.22)
                  : AppColors.subtleButtonBg),
          border: Border.all(
            color: (isCurrent || isDone)
                ? activeAccent
                : AppColors.borderGlass,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: isDone
            ? AppSvgIcons.checkmark(size: 14, color: activeAccent)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent
                      ? (index == 2 ? const Color(0xFF140F0A) : Colors.white)
                      : AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(bool active, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: 34,
      height: 2.5,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: active ? accent : AppColors.borderGlass,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
