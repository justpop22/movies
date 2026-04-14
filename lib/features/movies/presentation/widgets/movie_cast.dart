import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';

import '../../../../l10n/app_localizations.dart';
class MovieCast extends StatelessWidget {
  final List<dynamic> castList;

  const MovieCast({super.key, required this.castList});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (castList.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20).r,
      child: Column(
        children: castList.map((actor) {
          final String name = actor.name ?? locale.unknown;
          final String imageUrl = actor.urlSmallImage ?? "";
          final String characterName = actor.characterName ?? locale.unknown;

          return Container(
            margin: EdgeInsets.only(bottom: 12).r,
            padding: EdgeInsets.all(12).w,
            decoration: BoxDecoration(
              color: AppColors.headerBackground,
              borderRadius: BorderRadius.circular(12).w,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        characterName,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
