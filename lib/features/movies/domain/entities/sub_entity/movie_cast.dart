class MovieCast {
  final String name;
  final String characterName;
  final String? urlSmallImage;

  const MovieCast({
    required this.name,
    required this.characterName,
    this.urlSmallImage,
  });

  @override
  List<Object?> get props => [name, characterName];
}
