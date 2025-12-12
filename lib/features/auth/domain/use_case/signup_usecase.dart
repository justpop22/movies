import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/signup_params.dart';
import '../enitiy/user_entity.dart';
import '../repositories/auth_repo.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUp(params);
  }
}
