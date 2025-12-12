
abstract class MovieDetailsEvent {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetMovieDetailsEvent extends MovieDetailsEvent {
  final int id; // Or String, depending on your API
  const GetMovieDetailsEvent({required this.id});

  @override
  List<Object> get props => [id];
}