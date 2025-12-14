import 'package:flutter/material.dart';

class AppDialogs {
  static void showMessage(
    BuildContext context,
    String title, {
    DialogType type = DialogType.success,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        duration: Duration(seconds: 5),
        backgroundColor: type == DialogType.success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

enum DialogType { success, error }
