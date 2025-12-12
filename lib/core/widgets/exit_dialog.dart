import 'package:flutter/material.dart';
import 'package:movies/core/routes/app_route_name.dart';
import 'package:provider/provider.dart';
import '../../modules/auth/manager/auth_provider.dart';
import '../theme/app_colors.dart';

void showExitConfirmation(BuildContext context) {

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.headerBackground,
      title: const Text(
        "Sign Out?",
        style: TextStyle(color: AppColors.primaryText),
      ),
      content: const Text(
        "Are you sure you want to sign out?",
        style: TextStyle(color: AppColors.secondaryText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("Cancel", style: TextStyle(color: AppColors.primaryText)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();

            await context.read<AuthProvider>().logout(context);

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, RouteName.login, (route) => false);
            }
          },
          child: const Text("Sign Out", style: TextStyle(color: AppColors.dangerColor)),
        ),
      ],
    ),
  );
}