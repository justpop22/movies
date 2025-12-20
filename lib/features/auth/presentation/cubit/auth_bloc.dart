import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_case/deleteaccount_usecase.dart';
import '../../domain/use_case/forgotpassword_usecase.dart';
import '../../domain/use_case/getcurrentuser_usecase.dart';
import '../../domain/use_case/login_usecase.dart';
import '../../domain/use_case/loginwithgoogle_usecase.dart';
import '../../domain/use_case/logout_usecase.dart';
import '../../domain/use_case/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.loginWithGoogleUseCase,
    required this.deleteAccountUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUserUseCase.call();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase.call(event.params);
    result.fold(
          (failure) => emit(AuthError(failure.errMessagge)),
          (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signUpUseCase.call(event.params);
    result.fold(
      (failure) => emit(AuthError(failure.errMessagge)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginWithGoogleUseCase.call();
    result.fold(
      (failure) => emit(AuthError(failure.errMessagge)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase.call();
    emit(Unauthenticated());
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await deleteAccountUseCase.call();
    result.fold(
      (failure) => emit(AuthError(failure.errMessagge)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase.call(event.email);
    result.fold(
      (failure) => emit(AuthError(failure.errMessagge)),
      (_) => emit(
        const AuthActionSuccess("Password reset link sent to your email"),
      ),
    );
  }
}
