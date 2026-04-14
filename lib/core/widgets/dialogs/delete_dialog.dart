import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_event.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../routes/app_route_name.dart';
import '../../theme/app_colors.dart';

void showDeleteConfirmation(BuildContext context) {
  var locale = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) => BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
                (route) => false,
          );
        } else if (state is AuthError) {
          if (state.message.contains('log in again') || state.message.contains('recent-login')) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteName.login,
                  (route) => false,
            );
          }
        }
      },
      child: AlertDialog(
        backgroundColor: AppColors.headerBackground,
        title: Text(
          locale.deleteAccQ,
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Text(
          locale.thisActionNotUndo,
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              locale.cancel,
              style: TextStyle(color: AppColors.primaryText),
            ),
          ),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  context.read<AuthBloc>().add(DeleteAccountEvent());
                },
                child: isLoading
                    ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: AppColors.dangerColor,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  locale.delete,
                  style: TextStyle(color: AppColors.dangerColor),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}