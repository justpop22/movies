import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_event.dart';
import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

void showExitConfirmation(BuildContext context) {
  var locale = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.headerBackground,
      title: Text(
        locale.signOutQ,
        style: TextStyle(color: AppColors.primaryText),
      ),
      content: Text(
        locale.sureSignOut,
        style: TextStyle(color: AppColors.secondaryText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(
            locale.cancel,
            style: TextStyle(color: AppColors.primaryText),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            context.read<AuthBloc>().add(LogoutEvent());
          },
          child: Text(
            locale.signOut,
            style: TextStyle(color: AppColors.dangerColor),
          ),
        ),
      ],
    ),
  );
}
