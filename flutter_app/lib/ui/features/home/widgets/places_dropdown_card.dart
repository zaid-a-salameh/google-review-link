import 'package:flutter/material.dart';

import '../../../../domain/models/place_suggestion.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';

class PlacesDropdownCard extends StatelessWidget {
  const PlacesDropdownCard({
    super.key,
    required this.suggestions,
    required this.width,
    required this.onSelect,
    this.maxHeight = 290,
  });

  final List<PlaceSuggestion> suggestions;
  final double width;
  final ValueChanged<PlaceSuggestion> onSelect;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return NotificationListener<ScrollNotification>(
      onNotification: (_) => true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: AppColors.dropdownMenuBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.28),
                width: 1,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.isLight
                      ? const Color(0x24000000)
                      : const Color(0xAD000000),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.manual,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: AppColors.borderGlass,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final item = suggestions[index];
                        return InkWell(
                          onTap: () => onSelect(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Center(
                                    child: AppSvgIcons.placePin(
                                      size: 16,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        item.mainText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13.8,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      if (item
                                          .secondaryText.isNotEmpty) ...<Widget>[
                                        const SizedBox(height: 2),
                                        Text(
                                          item.secondaryText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      border: Border(
                        top: BorderSide(color: AppColors.borderGlass),
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'powered by',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.textMuted,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          AppSvgIcons.googleWordmark(width: 44, height: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
