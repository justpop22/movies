import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../repo/user_repo.dart';

class GetUserInfoUseCase {
  final UserRepository repository;
  GetUserInfoUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call() {
    return repository.getUserInfo();
  }
}
