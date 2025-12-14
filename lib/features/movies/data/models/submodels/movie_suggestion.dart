import '../../../../../core/databases/api/end_points.dart';
import '../../../domain/entities/sub_entity/movie_suggestion_sub_entity.dart';

class MovieSuggestionSubModel extends MovieSuggestionSubEntity {
  final String? url;
  final String? imdbCode;
  final String? titleEnglish;
  final String? titleLong;
  final String? slug;
  final int? year;
  final int? runtime;
  final List<String>? genres;
  final String? summary;
  final String? descriptionFull;
  final String? synopsis;
  final String? ytTrailerCode;
  final String? language;
  final String? mpaRating;
  final String? backgroundImage;
  final String? backgroundImageOriginal;
  final String? smallCoverImage;
  final String? dateUploaded;
  final int? dateUploadedUnix;

  MovieSuggestionSubModel({
    required super.id,
    required super.rating,
    required super.mediumCoverImage,
    this.url,
    this.imdbCode,
    required super.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.dateUploaded,
    this.dateUploadedUnix,
  });

  factory MovieSuggestionSubModel.fromJson(Map<String, dynamic> json) {
    return MovieSuggestionSubModel(
      id: json[ApiKey.id] ?? 0,

      rating: (json[ApiKey.rating] as num?)?.toDouble() ?? 0.0,
      mediumCoverImage: json[ApiKey.mediumCoverImage] ?? '',

      url: json[ApiKey.url] ?? '',
      imdbCode: json[ApiKey.imdbCode] ?? '',
      title: json[ApiKey.title] ?? '',
      titleEnglish: json[ApiKey.titleEnglish] ?? '',
      titleLong: json[ApiKey.titleLong] ?? '',
      slug: json[ApiKey.slug] ?? '',
      year: json[ApiKey.year] ?? 0,
      runtime: json[ApiKey.runtime] ?? 0,

      genres: json[ApiKey.genres] != null
          ? List<String>.from(json[ApiKey.genres])
          : [],
      summary: json[ApiKey.summary] ?? '',
      descriptionFull: json[ApiKey.descriptionFull] ?? '',
      synopsis: json[ApiKey.synopsis] ?? '',
      ytTrailerCode: json[ApiKey.ytTrailerCode] ?? '',
      language: json[ApiKey.language] ?? '',
      mpaRating: json[ApiKey.mpaRating] ?? '',
      backgroundImage: json[ApiKey.backgroundImage] ?? '',
      backgroundImageOriginal: json[ApiKey.backgroundImageOriginal] ?? '',
      smallCoverImage: json[ApiKey.smallCoverImage] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKey.id: id,
      ApiKey.url: url,
      ApiKey.imdbCode: imdbCode,
      ApiKey.title: title,
      ApiKey.titleEnglish: titleEnglish,
      ApiKey.titleLong: titleLong,
      ApiKey.slug: slug,
      ApiKey.year: year,
      ApiKey.rating: rating,
      ApiKey.runtime: runtime,
      ApiKey.genres: genres,
      ApiKey.summary: summary,
      ApiKey.descriptionFull: descriptionFull,
      ApiKey.synopsis: synopsis,
      ApiKey.ytTrailerCode: ytTrailerCode,
      ApiKey.language: language,
      ApiKey.mpaRating: mpaRating,
      ApiKey.backgroundImage: backgroundImage,
      ApiKey.backgroundImageOriginal: backgroundImageOriginal,
      ApiKey.smallCoverImage: smallCoverImage,
      ApiKey.mediumCoverImage: mediumCoverImage,
    };
  }
}
