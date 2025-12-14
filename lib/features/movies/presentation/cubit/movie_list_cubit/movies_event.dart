import '../../../../../core/params/movieparams.dart';

abstract class MoviesEvent {
  const MoviesEvent();
  @override
  List<Object> get props => [];
}

class GetMoviesEvent extends MoviesEvent {
  final MovieListParams params;
  const GetMoviesEvent({required this.params});
  @override
  List<Object> get props => [params];
}

class SearchMoviesEvent extends MoviesEvent {
  final String queryTerm;

  const SearchMoviesEvent({required this.queryTerm});

  @override
  List<Object> get props => [queryTerm];
}

class ResetSearchEvent extends MoviesEvent {}
