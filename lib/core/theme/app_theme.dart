import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.secondaryColor,
    ),
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.primaryColor,
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
      hintStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: Color(0xff282A28),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16).w,
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16).w,
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16).w,
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16).w,
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(fontSize: 14.sp, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16.sp, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 20.sp, color: Colors.white),
      titleSmall: TextStyle(
        fontSize: 16.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 18.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
