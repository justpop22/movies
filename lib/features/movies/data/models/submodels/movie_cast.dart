import '../../../domain/entities/sub_entity/movie_cast.dart';

class MovieCastModel extends MovieCast {
  const MovieCastModel({
    required super.name,
    required super.characterName,
    super.urlSmallImage,
  });

  factory MovieCastModel.fromJson(Map<String, dynamic> json) {
    return MovieCastModel(
      name: json['name'] ?? 'Unknown',
      characterName: json['character_name'] ?? 'Unknown',
      urlSmallImage: json['url_small_image'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': urlSmallImage,
    };
  }
}
