import 'package:movies/features/movies/domain/entities/sub_entity/movie_cast.dart';

class MovieDetailEntity {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final int likeCount;
  final String descriptionFull;
  final List<String> genres;
  final List<MovieCast> cast;
  final List<String> screenshots;
  final int year;
  final int runtime;

  const MovieDetailEntity({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.likeCount,
    required this.descriptionFull,
    required this.genres,
    required this.cast,
    required this.screenshots,
    required this.year,
    required this.runtime,
  });

  @override
  List<Object?> get props => [id, title, rating];
}
