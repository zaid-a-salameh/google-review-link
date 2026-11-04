import 'package:flutter/material.dart';

import '../../../domain/models/toast_message.dart';
import '../icons/app_svg_icons.dart';
import '../theme/app_colors.dart';

class ToastBannerOverlay extends StatelessWidget {
  const ToastBannerOverlay({
    super.key,
    required this.toast,
  });

  final ToastMessage? toast;

  Color _accentColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.warn:
        return AppColors.amberWifiLight;
      case ToastType.error:
      case ToastType.trash:
        return AppColors.dangerLight;
      case ToastType.copy:
      case ToastType.paste:
      case ToastType.info:
        return AppColors.primaryLight;
    }
  }

  Widget _buildIcon(ToastType type, Color accent) {
    switch (type) {
      case ToastType.success:
        return AppSvgIcons.checkmark(size: 16, color: accent);
      case ToastType.warn:
        return AppSvgIcons.warningTriangle(size: 16, color: accent);
      case ToastType.error:
        return AppSvgIcons.closeX(size: 16, color: accent);
      case ToastType.trash:
        return AppSvgIcons.trash(size: 16, color: accent);
      case ToastType.copy:
        return AppSvgIcons.copyIcon(size: 15, color: accent);
      case ToastType.paste:
        return AppSvgIcons.clipboardPaste(size: 15, color: accent);
      case ToastType.info:
        return AppSvgIcons.infoCircle(size: 16, color: accent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top + 12;

    return Positioned(
      top: topPadding,
      left: 18,
      right: 18,
      child: IgnorePointer(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, -0.45),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: slide,
                  child: child,
                ),
              );
            },
            child: toast == null
                ? const SizedBox.shrink()
                : _buildBanner(context, toast!),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, ToastMessage item) {
    final accent = _accentColor(item.type);
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Container(
        key: ValueKey<int>(item.id),
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.toastBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: accent.withValues(alpha: 0.38),
            width: 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.isLight
                  ? const Color(0x22000000)
                  : const Color(0x75000000),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildIcon(item.type, accent),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                item.message,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  decoration: TextDecoration.none,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
