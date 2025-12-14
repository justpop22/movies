import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '../repo/user_repo.dart';

class AddWatchHistoryUseCase {
  final UserRepository repository;
  AddWatchHistoryUseCase({required this.repository});

  Future<Either<Failure, void>> call(MovieSubEntity movie) {
    return repository.addWatchHistory(movie);
  }
}
