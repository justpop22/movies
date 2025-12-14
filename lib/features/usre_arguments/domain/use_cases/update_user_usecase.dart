import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../repo/user_repo.dart';

class UpdateUserInfoUseCase {
  final UserRepository repository;
  UpdateUserInfoUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return repository.updateUserInfo(user);
  }
}
