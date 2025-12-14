import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import '../../modules/home/pages/mvoei_details.dart';

class MovieGridItem extends StatelessWidget {
  final int movieId; // 1. Add ID to identify the movie
  final String imagePath;
  final String rating;

  const MovieGridItem({
    super.key,
    required this.movieId, // 2. Require it in the constructor
    required this.imagePath,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    // 3. Wrap everything in GestureDetector to handle clicks
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movieId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
            },
          ),
        ),
        child: Stack(
          children: [
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Rate Badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.secondaryColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}