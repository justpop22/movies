import 'package:movies/features/movies/domain/entities/sub_entity/movie_suggestion_sub_entity.dart';

class MovieSuggestionEntity {
  final List<MovieSuggestionSubEntity> movies;
  MovieSuggestionEntity({required this.movies});
}
