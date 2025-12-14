import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repo.dart';

class DeleteAccountUseCase {
  final AuthRepository repository;

  DeleteAccountUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.deleteAccount();
  }
}
