import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repo/user_repo.dart';

class RemoveWatchHistoryUseCase {
  final UserRepository repository;
  RemoveWatchHistoryUseCase({required this.repository});

  Future<Either<Failure, void>> call(int movieId) {
    return repository.removeWatchHistory(movieId);
  }
}
