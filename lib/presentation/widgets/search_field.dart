import 'dart:async';

import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/core/theme/app_icons.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    required this.hintText,
    required this.onChanged,
    super.key,
    this.debounceDuration = AppDimensions.searchDebounceDuration,
  });
  final String hintText;
  final ValueChanged<String> onChanged;
  final Duration debounceDuration;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(value);
    });
  }

  void _onClear() {
    _controller.clear();
    setState(() {});
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.searchFieldPadding,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(AppIcons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(AppIcons.clear),
                  onPressed: _onClear,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.searchFieldBorderRadius,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
