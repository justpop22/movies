class MovieSubEntity {
  final String largeCoverImage;
  final String mediumCoverImage;
  final String smallCoverImage;
  final double rating;
  final List<String> genres;
  final String title;
  final int id;

  const MovieSubEntity({
    required this.id,
    required this.largeCoverImage,
    required this.mediumCoverImage,
    required this.smallCoverImage,
    required this.rating,
    required this.genres,
    required this.title,
  });
}
