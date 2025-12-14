import 'package:movies/features/movies/domain/entities/sub_entity/movie.dart';

class MovieEntity {
  final List<MovieSubEntity> movie;

  const MovieEntity({required this.movie});
}
