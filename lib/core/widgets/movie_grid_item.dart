import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/modules/home/pages/movie_details_screen.dart';

class MovieGridItem extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieGridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String imagePath = movie['image'] ?? 'assets/placeholder.png';
    final String rating = movie['rate']?.toString() ?? 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      // 1. LayoutBuilder
      child: LayoutBuilder(
        builder: (context, constraints) {

          double cardWidth = constraints.maxWidth;


          double iconSize = cardWidth * 0.12;
          double fontSize = cardWidth * 0.10;
          double paddingH = cardWidth * 0.06;
          double paddingV = cardWidth * 0.03;
          double borderRadius = cardWidth * 0.08;

          iconSize = iconSize.clamp(12.0, 24.0);
          fontSize = fontSize.clamp(12.0, 20.0);

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),


                Positioned(
                  top: paddingH,
                  left: paddingH,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingH,
                        vertical: paddingV
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.secondaryColor,
                          size: iconSize,
                        ),
                        SizedBox(width: cardWidth * 0.02),
                        Text(
                          rating,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
