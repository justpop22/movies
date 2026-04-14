import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
class MovieScreenshots extends StatelessWidget {
  final List<String> screenshotUrls;

  const MovieScreenshots({super.key, required this.screenshotUrls});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (screenshotUrls.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          from: 20,
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Text(
              locale.screenshots,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20).r,
          child: Column(
            children: screenshotUrls.map((url) {
              return FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity.w,
                  height: 180.h,
                  margin: EdgeInsets.only(bottom: 15).r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.headerBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
