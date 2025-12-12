class MovieListParams {
  final int page;
  final int limit;
  final String? queryTerm; // For search
  final String? genre;     // e.g., 'Action'
  final String? sortBy;    // e.g., 'rating'
  final String? query;     // 'asc' or 'desc' (Note: standard API param is usually 'order_by')

  const MovieListParams({
    this.page = 1,
    this.limit = 20,
    this.queryTerm,
    this.genre,
    this.sortBy,
    this.query,
  });

  // ✅ CRITICAL: This method allows the BLoC to change the page
  // without losing the genre or search term.
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