import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_btn.dart';
import '../onboarding.dart';

class OnboardingScreen3 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Image.asset("assets/images/openhimer.png", fit: BoxFit.cover),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40).w,
                topRight: Radius.circular(40).w,
              ),
              child: Container(
                color: Color(0xff121312),
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ).r,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Explore All Genres",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.3.h,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        height: 1.4.h,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    ValueListenableBuilder<int>(
                      valueListenable: globalCurrentPage,
                      builder: (context, current, _) {
                        return Column(
                          children: [
                            CustomBtn(
                              isExpanded: true,
                              text: current == 0
                                  ? "Explore Now"
                                  : current == 5
                                  ? "Finish"
                                  : "Next",
                              onTap: () {
                                if (current == 5) {
                                  CacheManager.markFirstTimeComplete();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteName.login,
                                  );
                                  return;
                                }

                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                            Visibility(
                              visible: current != 0,
                              child: CustomBtn(
                                onTap: () {
                                  controller.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                text: "Back",
                                isExpanded: true,
                                buttomColor: AppColors.primaryColor,
                                textColor: AppColors.secondaryColor,
                                border: true,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
