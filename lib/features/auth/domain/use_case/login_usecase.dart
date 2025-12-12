import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/login_params.dart';
import '../enitiy/user_entity.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(params);
  }
}
