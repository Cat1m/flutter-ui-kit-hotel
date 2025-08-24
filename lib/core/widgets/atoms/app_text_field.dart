// lib/core/widgets/atoms/app_text_field.dart
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.hint,
    this.controller,
    this.prefix,
    this.onChanged,
  });
  final String? hint;
  final TextEditingController? controller;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(hintText: hint, prefixIcon: prefix),
    );
  }
}
