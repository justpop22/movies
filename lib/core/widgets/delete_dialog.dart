import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../features/auth/presentation/cubit/auth_event.dart';
import '../theme/app_colors.dart';

void showDeleteConfirmation(BuildContext context) {
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
          onPressed: () {
            Navigator.of(ctx).pop(); // Close the dialog

            // Trigger the Delete Event in AuthBloc
            // The BlocListener in your Screen will handle the navigation to Login
            context.read<AuthBloc>().add(DeleteAccountEvent());
          },
          child: const Text("Delete", style: TextStyle(color: AppColors.dangerColor)),
        ),
      ],
    ),
  );
}