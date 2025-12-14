import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/movie_detail_params.dart';
import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails({required this.repository});

  Future<Either<Failure, MovieDetailEntity>> call({
    required MovieDetailParams params,
  }) {
    return repository.getMovieDetails(params: params);
  }
}
