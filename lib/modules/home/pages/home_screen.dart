import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movies/modules/home/pages/main_layout.dart';

// Make sure these imports match your actual project structure
import '../../../core/temp/app_data.dart';
import '../../../core/widgets/movie_grid_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Start at a high number to allow scrolling left immediately.
  static const int _initialPage = 10000;
  static const int _infiniteItemCount = 20000;

  late final PageController _pageController;

  // Use a ValueNotifier to optimize rebuilds
  final ValueNotifier<double> _currentPageNotifier = ValueNotifier(_initialPage.toDouble());

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: _initialPage,
    );

    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page ?? _initialPage.toDouble();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.movies.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Map<String, dynamic>> actionMovies = AppData.getMoviesByCategory('Action');
    final List<Map<String, dynamic>> carouselMovies = AppData.movies;
    final int carouselLength = carouselMovies.length;
    // We calculate screen height to size the background appropriately within the scroll view
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      // 1. SingleChildScrollView is now the parent
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 2. The Background Image is now the first child of this Stack
            // It will scroll up as the user scrolls down
            SizedBox(
              height: screenHeight * 0.75, // Give it a fixed height within the scroll view
              width: double.infinity,
              child: ValueListenableBuilder<double>(
                valueListenable: _currentPageNotifier,
                builder: (context, pageValue, child) {
                  final int index = (pageValue.round()) % carouselLength;
                  final String bgImage = carouselMovies[index]['image'] as String;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Stack(
                      key: ValueKey(bgImage),
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          bgImage,
                          fit: BoxFit.cover,
                          key: ValueKey('bg_$bgImage'),
                        ),
                        // Dark Overlay
                        Container(color: Colors.black.withOpacity(0.45)),
                        // Blur Effect
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(color: Colors.black.withOpacity(0.2)),
                        ),
                        // Gradient to blend into the black background at the bottom
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.0),
                                Colors.black, // Fade to solid black at bottom
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. Main Content Column sits on top of the background in the Stack
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),

                // --- "Available Now" Header ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    'Available Now',
                    style: TextStyle(
                      fontFamily: 'CustomFancyFont',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // --- Infinite Carousel ---
                SizedBox(
                  height: 450.0,
                  child: AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        return PageView.builder(
                          controller: _pageController,
                          itemCount: _infiniteItemCount,
                          itemBuilder: (context, index) {
                            double page = _pageController.hasClients
                                ? (_pageController.page ?? _initialPage.toDouble())
                                : _initialPage.toDouble();

                            final double scale = (1 - (page - index).abs() * 0.2).clamp(0.7, 1.0);

                            final int movieIndex = index % carouselLength;
                            final movie = carouselMovies[movieIndex];
                            final String tagline = movie['category'];

                            return Transform.scale(
                              scale: scale,
                              child: _buildLargePoster(tagline, movie['image'], movie['rate'], context),
                            );
                          },
                        );
                      }),
                ),

                // --- "Watch Now" Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Watch Now',
                        style: TextStyle(
                          fontFamily: 'CustomFancyFont',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // "Action" Category Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Action',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 400),
                                  pageBuilder: (_, __, ___) => const MainLayout(
                                    initialIndex: 2,
                                    initialCategory: 'Action',
                                  ),
                                  transitionsBuilder: (_, animation, __, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    final tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: Curves.easeOut));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'See More',
                                  style: TextStyle(fontSize: 16, color: Colors.yellow),
                                ),
                                Icon(Icons.arrow_right_alt, color: Colors.yellow, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),

                      // The Action Movie List
                      SizedBox(
                        height: 170.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: actionMovies.length,
                          itemBuilder: (context, index) {
                            final movie = actionMovies[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: MovieGridItem(
                                rating: movie['rate'],
                                imagePath: movie['image'],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargePoster(String tagline, String imageUrl, String rate, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
