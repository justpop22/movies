import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart' as movie;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/routes/app_route_name.dart';
import 'package:movies/core/routes/route_gen.dart';
import 'package:movies/core/theme/app_colors.dart';
import '../../modules/layout/pages/movieDetails/movie_details.dart';

class MovieGridItem extends StatelessWidget {
  final int movieId;
  final String imagePath;
  final String rating;
  final String heroTag;

  const MovieGridItem({
    super.key,
    required this.movieId,
    required this.imagePath,
    required this.rating,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.movieDetail,
          arguments: {
            'movieId': movieId,
            'heroTag': heroTag,
            'imageUrl': imagePath,
          },
        );
      },
      child: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = constraints.maxWidth;

              double iconSize = (cardWidth * 0.12).clamp(10.0, 20.0);
              double fontSize = (cardWidth * 0.10).clamp(10.0, 18.0);
              double paddingH = cardWidth * 0.05;
              double paddingV = cardWidth * 0.02;
              double positionedOffset = cardWidth * 0.06;

              return CachedNetworkImage(
                imageUrl: imagePath,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10).w,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Dark Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10).w,
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
                      // Rating Badge
                      Positioned(
                        top: positionedOffset,
                        left: positionedOffset,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingH,
                            vertical: paddingV,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8).w,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.secondaryColor,
                                size: iconSize,
                              ),
                              SizedBox(width: (cardWidth * 0.03).w),
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
                ),
                // ⭐️ THE SECRET SAUCE FOR THE HERO ANIMATION ⭐️
                // Gives the Hero a physical block to fly before the network image loads
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10).w,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10).w,
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}