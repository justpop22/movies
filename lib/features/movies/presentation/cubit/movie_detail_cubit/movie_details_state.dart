import '../../../domain/entities/movie_detail_entity.dart';
import '../../../domain/entities/sub_entity/movie_suggestion_sub_entity.dart';

abstract class MovieDetailsState {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetailEntity movieDetail;
  final List<MovieSuggestionSubEntity> suggestions;

  const MovieDetailsLoaded({
    required this.movieDetail,
    required this.suggestions,
  });

  @override
  List<Object> get props => [movieDetail, suggestions];
}

class MovieDetailsFailure extends MovieDetailsState {
  final String message;

  const MovieDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}
