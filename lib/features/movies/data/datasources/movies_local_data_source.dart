import 'dart:convert';
import '../../../../core/databases/cache/cache_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/movie_model.dart';

class MovieLocalDataSource {
  final CacheHelper cache;
  final String key = "cachedMovies";

  MovieLocalDataSource({required this.cache});

  Future<void> cacheMovies(MovieList? moviesToCache) async {
    if (moviesToCache != null) {
      await cache.saveData(
        key: key,
        value: json.encode(moviesToCache.toJson()),
      );
    } else {
      throw CacheException(errorMessage: "No Internet Connection");
    }
  }

  Future<MovieList> getLastMovies() async {
    final jsonString = cache.getData(key: key);
    if (jsonString != null) {
      return Future.value(MovieList.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException(errorMessage: "No Cached Data Found");
    }
  }
}
