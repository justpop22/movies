import '../../../domain/entities/sub_entity/movie.dart';

abstract class MoviesState {
  const MoviesState();
  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<MovieSubEntity> movies;
  final bool hasReachedMax;

  const MoviesLoaded({required this.movies, this.hasReachedMax = false});

  MoviesLoaded copyWith({List<MovieSubEntity>? movies, bool? hasReachedMax}) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax];
}

class MoviesFailure extends MoviesState {
  final String message;
  const MoviesFailure(this.message);
  @override
  List<Object> get props => [message];
}
