import 'package:movies/features/movies/data/models/submodels/movies.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../domain/entities/movie_entity.dart';

class MovieList extends MovieEntity {
  final int? movieCount;
  final int? limit;
  final int? pageNumber;

  MovieList({
    required super.movie,
    required this.movieCount,
    required this.limit,
    required this.pageNumber,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      movieCount: json[ApiKey.movieCount],
      limit: json[ApiKey.limit],
      pageNumber: json[ApiKey.pageNumber],
      movie: json[ApiKey.movies] != null
          ? List<MovieModel>.from(
              json[ApiKey.movies].map((x) => MovieModel.fromJson(x)),
            )
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ApiKey.movieCount: movieCount,
      ApiKey.limit: limit,
      ApiKey.pageNumber: pageNumber,
      ApiKey.movies: movie?.map((v) {
        return v is MovieModel ? v.toJson() : {};
      }).toList(),
    };
  }
}
