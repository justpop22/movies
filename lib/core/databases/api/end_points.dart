class EndPoints {
  static const String baseUrl = "https://yts.lt/api/v2/";
  static const String listMovies = "list_movies.json";
  static const String movieDetails = "movie_details.json";
  static const String movieSuggestions = "movie_suggestions.json";
}

class ApiKey {
  // --- 1. Response Wrapper Keys ---
  static const String status = "status";
  static const String statusMessage = "status_message";
  static const String data = "data";
  static const String movie = "movie"; // <--- NEEDED: For Details Response data['movie']

  // --- 2. Pagination / Container Keys ---
  static const String movieCount = "movie_count";
  static const String limit = "limit";
  static const String pageNumber = "page_number"; // Response Key
  static const String movies = "movies";

  // --- 3. Request Parameters (What you send to API) ---
  // You were missing these!
  static const String page = "page";           // Request param (URL)
  static const String queryTerm = "query_term";// For Search
  static const String sortBy = "sort_by";      // For Sorting
  static const String genre = "genre";         // For Filtering
  static const String movieId = "movie_id";    // For Details Request
  static const String withImages = "with_images"; // Request param
  static const String withCast = "with_cast";     // Request param

  // --- 4. Movie Entity Keys ---
  static const String id = "id";
  static const String title = "title";
  static const String rating = "rating";
  static const String likeCount = "like_count"; // <--- NEEDED for Details
  static const String genres = "genres";

  // --- 5. Images ---
  static const String smallCoverImage = "small_cover_image";
  static const String mediumCoverImage = "medium_cover_image";
  static const String largeCoverImage = "large_cover_image";
  static const String backgroundImage = "background_image";
  static const String backgroundImageOriginal = "background_image_original";

  // --- 6. Details Specifics (Cast & Screenshots) ---
  // You were missing these for parsing MovieDetailModel!
  static const String cast = "cast";
  static const String name = "name";
  static const String characterName = "character_name";
  static const String urlSmallImage = "url_small_image"; // Actor Image

  static const String largeScreenshot1 = "large_screenshot_image1";
  static const String largeScreenshot2 = "large_screenshot_image2";
  static const String largeScreenshot3 = "large_screenshot_image3";

  // --- 7. Other Fields (Optional) ---
  static const String url = "url";
  static const String imdbCode = "imdb_code";
  static const String titleEnglish = "title_english";
  static const String titleLong = "title_long";
  static const String slug = "slug";
  static const String year = "year";
  static const String runtime = "runtime";
  static const String summary = "summary";
  static const String descriptionFull = "description_full";
  static const String synopsis = "synopsis";
  static const String ytTrailerCode = "yt_trailer_code";
  static const String language = "language";
  static const String mpaRating = "mpa_rating";

}