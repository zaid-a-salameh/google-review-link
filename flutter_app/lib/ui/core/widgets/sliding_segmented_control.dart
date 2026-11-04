import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SegmentedTabItem {
  const SegmentedTabItem({
    required this.label,
    this.iconBuilder,
    this.semanticKey,
  });

  final String label;
  final Widget Function(bool isSelected)? iconBuilder;
  final Key? semanticKey;
}

class SlidingSegmentedControl extends StatelessWidget {
  const SlidingSegmentedControl({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 46,
    this.borderRadius = 15,
    this.padding = 4,
    this.iconAboveLabel = false,
    this.trackColor,
    this.trackBorderColor,
    this.pillGradient,
    this.pillBorderColor = const Color(0x66A78BFA),
    this.pillShadowColor = const Color(0x388B5CF6),
    this.activeTextColor,
    this.inactiveTextColor,
    this.fontSize = 13.5,
    this.fontWeight = FontWeight.w700,
  }) : assert(items.length >= 2, 'Designed for segmented switches with at least 2 items');

  final List<SegmentedTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double borderRadius;
  final double padding;
  final bool iconAboveLabel;
  final Color? trackColor;
  final Color? trackBorderColor;
  final Gradient? pillGradient;
  final Color pillBorderColor;
  final Color pillShadowColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final innerRadius = (borderRadius - padding).clamp(8.0, borderRadius);
    final count = items.length;
    final double xAlign = count <= 1
        ? 0.0
        : -1.0 + (selectedIndex * (2.0 / (count - 1)));
    final effectiveTrackColor = trackColor ?? AppColors.pillTrackBg;
    final effectiveTrackBorder = trackBorderColor ?? AppColors.borderGlass;
    final effectivePillGradient = pillGradient ?? AppColors.reviewPillGradient;
    final effectiveActiveText = activeTextColor ?? Colors.white;
    final effectiveInactiveText = inactiveTextColor ?? AppColors.textSub;

    return Container(
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: effectiveTrackColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveTrackBorder, width: 1),
      ),
      child: Stack(
        children: <Widget>[
          AnimatedAlign(
            alignment: AlignmentDirectional(xAlign, 0.0),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 1.0 / count,
              heightFactor: 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: effectivePillGradient,
                  borderRadius: BorderRadius.circular(innerRadius),
                  border: Border.all(color: pillBorderColor, width: 1),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: pillShadowColor,
                      blurRadius: 14,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: List<Widget>.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  key: item.semanticKey,
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(index),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: iconAboveLabel
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (item.iconBuilder != null) ...<Widget>[
                                  item.iconBuilder!(isSelected),
                                  const SizedBox(height: 5),
                                ],
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.fontFamily,
                                    color: isSelected
                                        ? effectiveActiveText
                                        : effectiveInactiveText,
                                    fontSize: fontSize,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : fontWeight,
                                    height: 1.2,
                                  ),
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (item.iconBuilder != null) ...<Widget>[
                                  item.iconBuilder!(isSelected),
                                  const SizedBox(width: 6),
                                ],
                                Flexible(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.fontFamily,
                                      color: isSelected
                                          ? effectiveActiveText
                                          : effectiveInactiveText,
                                      fontSize: fontSize,
                                      fontWeight: fontWeight,
                                      height: 1.2,
                                    ),
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
