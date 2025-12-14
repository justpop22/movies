class MovieListParams {
  final int page;
  final int limit;
  final String? queryTerm;
  final String? genre;
  final String? sortBy;
  final String? query;

  const MovieListParams({
    this.page = 1,
    this.limit = 20,
    this.queryTerm,
    this.genre,
    this.sortBy,
    this.query,
  });

  MovieListParams copyWith({
    int? page,
    int? limit,
    String? queryTerm,
    String? genre,
    String? sortBy,
    String? query,
  }) {
    return MovieListParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      queryTerm: queryTerm ?? this.queryTerm,
      genre: genre ?? this.genre,
      sortBy: sortBy ?? this.sortBy,
      query: query ?? this.query,
    );
  }
}
