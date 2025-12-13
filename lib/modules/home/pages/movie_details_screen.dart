import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';
import 'package:movies/core/temp/app_data.dart';
import 'package:movies/core/widgets/movie_stats_section.dart';
import 'package:movies/core/widgets/movie_cast_section.dart';



// --- Dummy Data ---
const String _dummySummary =
    'Following the events of Spider-Man: No Way Home and Loki season 1, Dr. Stephen Strange continues his research on the Time Stone. But when an old friend, Wanda Maximoff, appears to have succumbed to the Darkhold, Strange must confront her as she attempts to seize the powerful artifact known as the Darkhold.';

const List<String> _dummyGenres = [
  'Action',
  'Sci-Fi',
  'Fantasy',
  'Horror',
  'Adventure',
];

const List<String> _dummyScreenshots = [
  'assets/temp/screenshot1.png',
  'assets/temp/screenshot2.png',
  'assets/temp/screenshot3.png',
];

const List<Map<String, String>> _dummyCast = [
  {
    'name': 'Namr',
    'character': 'Hayley Atwelli',
    'image': 'assets/temp/cast1.png',
  },
  {
    'name': 'Dior',
    'character': 'Captain Marvel',
    'image': 'assets/temp/cast2.png',
  },
  {'name': 'Dave', 'character': 'Wong', 'image': 'assets/temp/cast1.png'},
  {
    'name': 'Rachel',
    'character': 'Dr. Christine Palmer',
    'image': 'assets/temp/cast2.png',
  },
];

const String _dummyDuration = '90';

class MovieDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isBookMarked = false;
  @override
  Widget build(BuildContext context) {

    final String title = widget.movie['title'] ?? 'Unknown Movie';
    final String rating = widget.movie['rate']?.toString() ?? 'N/A';
    final String posterPath = widget.movie['image'] ?? 'assets/placeholder.png';
    const String year = '2022';

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, posterPath, year, title),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dangerColor,
                        foregroundColor: AppColors.primaryText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Watch',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),


                MovieStatsSection(rating: rating, duration: _dummyDuration),

                // 4. Screen Shots
                _buildSectionTitle('Screen Shots'),
                _buildScreenshotsList(),

                // 5. Similar Movies
                _buildSectionTitle('Similar'),
                _buildSimilarMoviesList(),

                // 6. Summary
                _buildSectionTitle('Summary'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _dummySummary,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),

                // 7. Cast
                _buildSectionTitle('Cast'),
                const MovieCastSection(castList: _dummyCast),

                // 8. Genres
                _buildSectionTitle('Genres'),
                _buildGenresRow(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    String posterPath,
    String year,
    String title,
  ) {
    return SliverAppBar(
      backgroundColor: AppColors.headerBackground,
      expandedHeight: 450.0,
      pinned: false,
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              posterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColors.headerBackground),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    AppColors.mainBackground,
                  ],
                  stops: [0.5, 0.8, 1.0],
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  size: 45,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 15,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 15,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isBookMarked = !isBookMarked;
                  });
                },
                icon: Icon(
                  isBookMarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookMarked ? AppColors.secondaryColor : Colors.white,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 10.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    year,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenshotsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _dummyScreenshots
            .map(
              (path) => Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    path,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSimilarMoviesList() {
    final similarMovies = AppData.movies.take(4).toList();
    return Container(
      height: 230,
      margin: const EdgeInsets.only(bottom: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: similarMovies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 130,
              child: MovieGridItem(movie: similarMovies[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenresRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _dummyGenres
            .map(
              (genre) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.headerBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  genre,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
