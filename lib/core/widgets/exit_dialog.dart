import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../features/auth/presentation/cubit/auth_event.dart';
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
          onPressed: () {
            Navigator.of(ctx).pop(); // Close the dialog

            // Trigger Logout Event in AuthBloc
            // The BlocListener in your screen will detect 'Unauthenticated' state and navigate to Login
            context.read<AuthBloc>().add(LogoutEvent());
          },
          child: const Text("Sign Out", style: TextStyle(color: AppColors.dangerColor)),
        ),
      ],
    ),
  );
}