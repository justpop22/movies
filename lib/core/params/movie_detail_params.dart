class MovieDetailParams {
  final int movieId;
  final bool withImages;
  final bool withCast;

  const MovieDetailParams({
    required this.movieId,
    this.withImages = true,
    this.withCast = true,
  });
}
