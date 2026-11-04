import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AmbientGlowScaffold extends StatelessWidget {
  const AmbientGlowScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      color: AppColors.bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const IgnorePointer(
            child: RepaintBoundary(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -160,
                    right: -160,
                    width: 520,
                    height: 520,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            Color(0x1E8B5CF6),
                            Color(0x0A8B5CF6),
                            Color(0x008B5CF6),
                          ],
                          stops: <double>[0.0, 0.52, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -180,
                    left: -170,
                    width: 520,
                    height: 520,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            Color(0x187C3AED),
                            Color(0x087C3AED),
                            Color(0x007C3AED),
                          ],
                          stops: <double>[0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
      ),
    );
  }
}
