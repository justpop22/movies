import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../enitiy/user_entity.dart';
import '../repositories/auth_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call() {
    return repository.getCurrentUser();
  }
}
