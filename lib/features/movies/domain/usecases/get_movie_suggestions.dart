import 'package:dartz/dartz.dart';
import 'package:movies/features/movies/domain/entities/movie_suggestion_enity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/movie_detail_params.dart';
import '../../../../core/params/movie_suggestion_params.dart';
import '../entities/movie_detail_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieSuggestions {
  final MovieRepository repository;

  GetMovieSuggestions({required this.repository});

  Future<Either<Failure, MovieSuggestionEntity>> call({
    required MovieSuggestionParams params,
  }) {
    return repository.getMovieSuggestions(params: params);
  }
}
