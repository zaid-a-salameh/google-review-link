import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Future<T?> showAppMorphDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String barrierLabel = 'Dismiss',
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (
      BuildContext dialogContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return builder(dialogContext);
    },
    transitionBuilder: (
      BuildContext dialogContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final scale = Tween<double>(begin: 0.92, end: 1.0).animate(curved);

      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FadeTransition(
            opacity: curved,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: barrierDismissible
                  ? () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(dialogContext).maybePop();
                    }
                  : null,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: ColoredBox(
                  color: AppColors.modalBarrier,
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: scale,
              child: child,
            ),
          ),
        ],
      );
    },
  ).then((result) {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    return result;
  });
}
