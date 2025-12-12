class AppData {
  static final List<Map<String, dynamic>> movies = [
    {
      'title': 'Black Widow',
      'rate': '7.0',
      'image': "assets/temp/blackwidow.png",
      'category': 'Drama',
    },
    {
      'title': '1917',
      'rate': '8.3',
      'image': "assets/temp/1917.png",
      'category': 'Action',
    },
    {
      'title': 'Avengers',
      'rate': '8.4',
      'image': "assets/temp/avengers.png",
      'category': 'Adventure',
    },
    {
      'title': 'Joker',
      'rate': '8.5',
      'image': "assets/temp/the joker.png",
      'category': 'Drama',
    },
    {
      'title': 'Black Panther',
      'rate': '7.3',
      'image': "assets/temp/Black Panther.png",
      'category': 'Adventure',
    },
    {
      'title': 'Iron Man',
      'rate': '7.9',
      'image': "assets/temp/Iron Man.png",
      'category': 'Action',
    },
  ];
  static List<Map<String, dynamic>> getMoviesByCategory(String category) {
    return movies.where((movie) => movie['category'] == category).toList();
  }
}
