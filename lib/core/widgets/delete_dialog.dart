import 'package:flutter/material.dart';
import 'package:movies/core/routes/app_route_name.dart';
import 'package:provider/provider.dart';
import '../../modules/auth/manager/auth_provider.dart';
import '../theme/app_colors.dart';

void showDeleteConfirmation(BuildContext context) {
  final authProvider = context.read<AuthProvider>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.headerBackground,
      title: const Text(
        "Delete Account?",
        style: TextStyle(color: AppColors.primaryText),
      ),
      content: const Text(
        "This action cannot be undone. Are you sure?",
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

            bool success = await authProvider.deleteUserAccount(context);

            if (success && context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, RouteName.login, (route) => false);
            }
          },
          child: const Text("Delete", style: TextStyle(color: AppColors.dangerColor)),
        ),
      ],
    ),
  );
}