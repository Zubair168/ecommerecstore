import 'package:flutter/material.dart';

/// Professional Search Bar with refined design and shadow
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search Products...',
    this.onTap,
    this.onChanged,
    this.onFilterTap,
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        autofocus: autofocus,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(color: Color(0xFF101828), fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF98A2B3), size: 22),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Color(0xFFFF5722), size: 20),
                  onPressed: onFilterTap,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
