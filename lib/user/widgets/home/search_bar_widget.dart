
import 'package:flutter/material.dart';
import 'package:shoppee_world/user/core/theme/app_tokens.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) return;

    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Keep the focus state synchronized with the current focus.
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 46,
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        border: Border.all(
          color: _isFocused
              ? AppTokens.accent
              : AppTokens.border,
          width: _isFocused ? 1.4 : 1,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && mounted) {
            setState(() {
              _isFocused = false;
            });
          }
        },
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: AppTokens.bodyStrong.copyWith(
            fontSize: 13,
            color: AppTokens.textPrimary,
          ),
          cursorColor: AppTokens.accent,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search for products..',
            hintStyle: AppTokens.body.copyWith(
              fontSize: 13,
              color: AppTokens.textTertiary,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppTokens.textSecondary,
              size: 21,
            ),
            suffixIcon:
                ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                if (value.text.isNotEmpty) {
                  return IconButton(
                    onPressed: widget.controller.clear,
                    tooltip: 'Clear search',
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppTokens.textSecondary,
                      size: 19,
                    ),
                  );
                }

                return IconButton(
                  onPressed: widget.onFilterTap,
                  tooltip: 'Filter products',
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: AppTokens.textSecondary,
                    size: 19,
                  ),
                );
              },
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppTokens.radiusLg),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppTokens.radiusLg),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppTokens.radiusLg),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

