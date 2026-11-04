import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/models/link_mode_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/icons/app_svg_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../../../core/widgets/sliding_segmented_control.dart';
import '../view_models/home_view_model.dart';
import 'places_dropdown_card.dart';

class MainInputCard extends StatefulWidget {
  const MainInputCard({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<MainInputCard> createState() => _MainInputCardState();
}

class _MainInputCardState extends State<MainInputCard> {
  final FocusNode _urlFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final Object _searchTapRegionGroup = Object();
  final LayerLink _searchLayerLink = LayerLink();
  final OverlayPortalController _dropdownOverlayController =
      OverlayPortalController();
  final GlobalKey _searchBoxKey = GlobalKey();
  double _searchBoxWidth = 320;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    widget.viewModel.addListener(_syncOverlayVisibility);
  }

  @override
  void didUpdateWidget(covariant MainInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_syncOverlayVisibility);
      widget.viewModel.addListener(_syncOverlayVisibility);
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _urlFocusNode.dispose();
    _searchFocusNode.dispose();
    widget.viewModel.removeListener(_syncOverlayVisibility);
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      _scrollToSearchInput();
    }
  }

  void _scrollToSearchInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future<void>.delayed(const Duration(milliseconds: 140), () {
        if (!mounted || !_searchFocusNode.hasFocus) return;
        final targetCtx = _searchBoxKey.currentContext;
        if (targetCtx == null || !targetCtx.mounted) return;
        Scrollable.ensureVisible(
          targetCtx,
          alignment: 0.0,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      });
    });
  }

  void _syncOverlayVisibility() {
    if (!mounted) return;
    final shouldShow = widget.viewModel.activeMode == AppInputMode.search &&
        widget.viewModel.isDropdownOpen &&
        widget.viewModel.placeSuggestions.isNotEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox =
          _searchBoxKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        _searchBoxWidth = renderBox.size.width;
      }
      if (shouldShow && !_dropdownOverlayController.isShowing) {
        _dropdownOverlayController.show();
        final targetCtx = _searchBoxKey.currentContext;
        if (targetCtx != null) {
          Scrollable.ensureVisible(
            targetCtx,
            alignment: 0.0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      } else if (!shouldShow && _dropdownOverlayController.isShowing) {
        _dropdownOverlayController.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final l10n = AppLocalizations.of(context)!;
    final isLinkMode = vm.activeMode == AppInputMode.link;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Mode Tabs: Direct Link | Find Business
          SlidingSegmentedControl(
            selectedIndex: isLinkMode ? 0 : 1,
            onChanged: (idx) {
              _urlFocusNode.unfocus();
              _searchFocusNode.unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
              vm.switchMode(
                idx == 0 ? AppInputMode.link : AppInputMode.search,
              );
            },
            items: <SegmentedTabItem>[
              SegmentedTabItem(
                semanticKey: const Key('tab_mode_link'),
                label: l10n.tabLink,
                iconBuilder: (selected) => AppSvgIcons.linkChain(
                  size: 17,
                  color: selected ? Colors.white : AppColors.textSub,
                ),
              ),
              SegmentedTabItem(
                semanticKey: const Key('tab_mode_search'),
                label: l10n.tabSearch,
                iconBuilder: (selected) => AppSvgIcons.searchMagnifier(
                  size: 17,
                  color: selected ? Colors.white : AppColors.textSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Directional Mode Stage
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 230),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (
                Widget? currentChild,
                List<Widget> previousChildren,
              ) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    ...previousChildren,
                    ?currentChild,
                  ],
                );
              },
            transitionBuilder: (child, anim) {
                final enteringLink =
                    child.key == const ValueKey<AppInputMode>(AppInputMode.link);
                final rtlSign = isRtl ? -1.0 : 1.0;
                final dir = enteringLink ? -1.0 : 1.0;
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(dir * rtlSign * 0.12, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<AppInputMode>(
                  isLinkMode ? AppInputMode.link : AppInputMode.search,
                ),
                child: KeyedSubtree(
                  key: ValueKey<bool>(AppColors.isLight),
                  child: isLinkMode
                      ? _buildDirectLinkPane(context, vm, l10n)
                      : _buildSearchBusinessPane(context, vm, l10n),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static TextDirection _resolveInputDirection(
    String text,
    TextDirection defaultDirection,
  ) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return defaultDirection;
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(trimmed)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  Widget _buildDirectLinkPane(
    BuildContext context,
    HomeViewModel vm,
    AppLocalizations l10n,
  ) {
    final ambientDirection = Directionality.of(context);

    return Column(
      key: const ValueKey<AppInputMode>(AppInputMode.link),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: vm.urlController,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;
            final inputDirection =
                _resolveInputDirection(value.text, ambientDirection);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Row(
                children: <Widget>[
                  if (hasText)
                    PressableScale(
                      key: const Key('btn_clear_url'),
                      onTap: () {
                        _urlFocusNode.unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                        vm.clearDirectUrl(l10n);
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsetsDirectional.only(end: 6),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AppSvgIcons.trash(
                            size: 16,
                            color: AppColors.dangerLight,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      key: const Key('input_direct_url'),
                      focusNode: _urlFocusNode,
                      controller: vm.urlController,
                      textDirection: inputDirection,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      onTapOutside: (_) {
                        _urlFocusNode.unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: (val) =>
                          vm.onDirectUrlChanged(val, l10n: l10n),
                      onSubmitted: (_) {
                        _urlFocusNode.unfocus();
                        FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        vm.convertDirectUrl(l10n: l10n);
                      },
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.2,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.placeholder,
                        hintStyle: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  PressableScale(
                    key: const Key('btn_paste_url'),
                    onTap: () {
                      _urlFocusNode.unfocus();
                      FocusScope.of(context).unfocus();
                      FocusManager.instance.primaryFocus?.unfocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      vm.pasteFromClipboard(l10n);
                    },
                    child: Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primaryLight.withValues(alpha: 0.30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AppSvgIcons.clipboardPaste(
                            size: 14,
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            l10n.pasteBtn,
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        PressableScale(
          key: const Key('btn_convert_link'),
          enabled: !vm.isResolvingLink,
          onTap: () {
            _urlFocusNode.unfocus();
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            vm.convertDirectUrl(l10n: l10n);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.36),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (vm.isResolvingLink)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                else
                  AppSvgIcons.linkChain(size: 19, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  vm.isResolvingLink ? l10n.resolvingBtn : l10n.convertBtn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBusinessPane(
    BuildContext context,
    HomeViewModel vm,
    AppLocalizations l10n,
  ) {
    return OverlayPortal(
      key: const ValueKey<AppInputMode>(AppInputMode.search),
      controller: _dropdownOverlayController,
      overlayChildBuilder: (BuildContext overlayContext) {
        final mediaQuery = MediaQuery.of(overlayContext);
        final keyboardInset = mediaQuery.viewInsets.bottom;
        final screenHeight = mediaQuery.size.height;

        double dynamicMaxHeight = 290;
        final renderBox =
            _searchBoxKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          final searchBoxBottom =
              renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height;
          final availableHeight =
              screenHeight - keyboardInset - searchBoxBottom - 16;
          if (availableHeight > 100) {
            dynamicMaxHeight = availableHeight.clamp(140.0, 290.0);
          }
        }

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _searchFocusNode.unfocus();
                  FocusManager.instance.primaryFocus?.unfocus();
                  vm.hideDropdown();
                },
              ),
            ),
            CompositedTransformFollower(
              link: _searchLayerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 8),
              child: TapRegion(
                groupId: _searchTapRegionGroup,
                child: PlacesDropdownCard(
                  width: _searchBoxWidth,
                  maxHeight: dynamicMaxHeight,
                  suggestions: vm.placeSuggestions,
                  onSelect: (suggestion) {
                    _searchFocusNode.unfocus();
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    vm.selectPlaceSuggestion(suggestion, l10n: l10n);
                  },
                ),
              ),
            ),
          ],
        );
      },
      child: CompositedTransformTarget(
        link: _searchLayerLink,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: vm.searchController,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;
            return TapRegion(
              groupId: _searchTapRegionGroup,
              child: Container(
                key: _searchBoxKey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: vm.isDropdownOpen
                        ? AppColors.primaryLight.withValues(alpha: 0.45)
                        : AppColors.borderGlass,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    AppSvgIcons.searchMagnifier(
                      size: 18,
                      color: AppColors.primaryLight,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        key: const Key('input_business_search'),
                        groupId: _searchTapRegionGroup,
                        focusNode: _searchFocusNode,
                        controller: vm.searchController,
                        textDirection: _resolveInputDirection(
                          value.text,
                          Directionality.of(context),
                        ),
                        textInputAction: TextInputAction.search,
                        onTapOutside: (_) {
                          _searchFocusNode.unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onChanged: (val) =>
                            vm.onSearchQueryChanged(val, l10n: l10n),
                        onSubmitted: (_) {
                          _searchFocusNode.unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14.2,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.searchPlaceholder,
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (vm.isSearchingPlaces) ...<Widget>[
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (hasText)
                      PressableScale(
                        key: const Key('btn_clear_search'),
                        onTap: () {
                          _searchFocusNode.unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          vm.clearSearchInput(l10n: l10n);
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: AppSvgIcons.trash(
                              size: 16,
                              color: AppColors.dangerLight,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
