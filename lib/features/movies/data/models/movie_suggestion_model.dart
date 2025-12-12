import 'package:movies/features/movies/data/models/submodels/movie_suggestion.dart';
import 'package:movies/features/movies/domain/entities/movie_suggestion_enity.dart';

import '../../../../core/databases/api/end_points.dart';
import '../../domain/entities/sub_entity/movie_suggestion_sub_entity.dart';

class MovieSuggestionModel extends MovieSuggestionEntity {
  int? movieCount;
  MovieSuggestionModel({this.movieCount, required super.movies});
  factory MovieSuggestionModel.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionModel(
      movieCount: json[ApiKey.movieCount] ?? 0,

      movies: json[ApiKey.movies] != null
          ? List<MovieSuggestionSubModel>.from(
              (json[ApiKey.movies] as List).map(
                (x) => MovieSuggestionSubModel.fromJson(x),
              ),
            )
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      ApiKey.movieCount: movieCount,
      ApiKey.movies: movies.map((v) {
        return v is MovieSuggestionSubModel ? v.toJson() : {};
      }).toList(),
    };
  }
}
