SizedBox(
height: 0.65.sh,
child: Stack(
children: [
Positioned.fill(
child: BlocBuilder<MoviesBloc, MoviesState>(
bloc: _trendingBloc,
builder: (context, state) {
if (state is! MoviesLoaded || state.movies.isEmpty) {
return Container(color: Colors.black);
}

return ValueListenableBuilder<int>(
valueListenable: _currentIndexNotifier,
builder: (context, index, _) {
final safeIndex = index.clamp(
0,
state.movies.length - 1,
);
final movie = state.movies[safeIndex];
final imagePath =
movie.largeCoverImage ??
movie.mediumCoverImage ??
"";

return AnimatedSwitcher(
duration: const Duration(milliseconds: 500),
child: Stack(
key: ValueKey(imagePath),
fit: StackFit.expand,
children: [
if (imagePath.isNotEmpty)
Image.network(
imagePath,
fit: BoxFit.cover,
errorBuilder: (_, __, ___) =>
const SizedBox(),
),
Container(
color: Colors.black.withOpacity(0.4),
),
BackdropFilter(
filter: ImageFilter.blur(
sigmaX: 8.0,
sigmaY: 8.0,
),
child: Container(
color: Colors.black.withOpacity(0.2),
),
),
],
),
);
},
);
},
),
),

Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(height: 30.h),

Padding(
padding: EdgeInsets.symmetric(horizontal: 25.0).r,
child: Center(
child: Text(
"Available Now",
style: GoogleFonts.protestRevolution (
textStyle: TextStyle(
fontSize: 40.sp,
color: Colors.white,
letterSpacing: 1.2,
),
),
),
),
),

SizedBox(
height: 0.45.sh,
child: BlocBuilder<MoviesBloc, MoviesState>(
bloc: _trendingBloc,
builder: (context, state) {
if (state is MoviesLoading) {
return const Center(
child: CircularProgressIndicator(
color: AppColors.secondaryColor,
),
);
}
if (state is MoviesLoaded) {
return PageView.builder(
controller: _pageController,
itemCount: state.movies.length,
onPageChanged: (index) {
_currentIndexNotifier.value = index;
},
itemBuilder: (context, index) {
final movie = state.movies[index];

return AnimatedBuilder(
animation: _pageController,
builder: (context, child) {
double page = index.toDouble();
if (_pageController.position.haveDimensions) {
page = _pageController.page ?? index.toDouble();
}
final double scale =
(1 - (page - index).abs() * 0.15).clamp(0.85, 1.0);

return Transform.scale(
scale: scale,
child: child,
);
},
child: GestureDetector(
onTap: () {
Navigator.push(
context,
PageRouteBuilder(
transitionDuration: const Duration(milliseconds: 600),
reverseTransitionDuration: const Duration(milliseconds: 500),
pageBuilder: (context, animation, secondaryAnimation) => MovieDetailsScreen(
imageUrl: movie.largeCoverImage ?? movie.mediumCoverImage ?? "",
movieId: movie.id,
heroTag: 'movie_hero_${movie.id}',
),
transitionsBuilder: (context, animation, secondaryAnimation, child) {
return FadeTransition(
opacity: CurveTween(curve: Curves.easeOut).animate(animation),
child: child,
);
},
),
);
},
child: Hero(
tag: 'movie_hero_${movie.id}',
child: Material(
type: MaterialType.transparency,
child: _buildLargePoster(
movie.largeCoverImage ?? movie.mediumCoverImage ?? "",
movie.rating.toString(),
),
),
),
),
);
},
);
}
return const SizedBox();
},
),
),
Padding(
padding: EdgeInsets.symmetric(horizontal: 25.0).r,
child: Center(
child: Text(
"Watch Now",
style: GoogleFonts.protestRevolution(
textStyle: TextStyle(
fontSize: 40.sp,
color: Colors.white,
letterSpacing: 1.2,
),
),
),
),
),
],
),
],
),
),
