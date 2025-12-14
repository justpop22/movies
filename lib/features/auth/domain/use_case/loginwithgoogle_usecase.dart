import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../enitiy/user_entity.dart';
import '../repositories/auth_repo.dart';

class LoginWithGoogleUseCase {
  final AuthRepository repository;
  LoginWithGoogleUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call() {
    return repository.signInWithGoogle();
  }
}
