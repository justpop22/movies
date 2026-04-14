import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType inputType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: AppColors.primaryText, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputFillColor,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.disabledText),
        prefixIcon: Icon(icon, color: AppColors.primaryText),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12).w,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12).w,
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12).w,
          borderSide: const BorderSide(
            color: AppColors.secondaryColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
