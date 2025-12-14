abstract class MovieDetailsEvent {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetMovieDetailsEvent extends MovieDetailsEvent {
  final int id;
  const GetMovieDetailsEvent({required this.id});

  @override
  List<Object> get props => [id];
}
