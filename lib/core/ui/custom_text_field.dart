import 'package:flutter/material.dart';
import 'package:parkingnow_owner/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: isDark ? Colors.blue[200] : AppColors.primary)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? const Color(0xFF23272F) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.blue[200]! : AppColors.inputBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.blueAccent : AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}