import 'package:movies/core/databases/api/end_points.dart';
import 'package:movies/features/movies/data/models/submodels/movie_cast.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/entities/sub_entity/movie_cast.dart';

class MovieDetailModel extends MovieDetailEntity {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.posterUrl,
    required super.rating,
    required super.likeCount,
    required super.descriptionFull,
    required super.genres,
    required super.cast,
    required super.screenshots,
    required super.year,
    required super.runtime,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] ?? 0,
      runtime: json['runtime'] ?? 0,
      year: json['year'] ?? '',
      title: json['title'] ?? '',
      posterUrl:
          json['large_cover_image'] ??
          json['medium_cover_image'] ??
          json['small_cover_image'] ??
          '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      likeCount: json['like_count'] ?? 0,
      descriptionFull: json['description_full'] ?? '',
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],

      cast: json['cast'] != null
          ? List<MovieCast>.from(
              (json['cast'] as List).map((x) => MovieCastModel.fromJson(x)),
            )
          : [],

      screenshots: _parseScreenshots(json),
    );
  }

  static List<String> _parseScreenshots(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['large_screenshot_image1'] != null)
      images.add(json['large_screenshot_image1']);
    if (json['large_screenshot_image2'] != null)
      images.add(json['large_screenshot_image2']);
    if (json['large_screenshot_image3'] != null)
      images.add(json['large_screenshot_image3']);
    return images;
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.title: title,
      ApiKey.rating: rating,
      ApiKey.likeCount: likeCount,
      ApiKey.descriptionFull: descriptionFull,
      ApiKey.genres: genres,
      ApiKey.cast: cast,
      ApiKey.mediumCoverImage: posterUrl,
      ApiKey.year: year,
      ApiKey.runtime: runtime,
    };
  }
}
