import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_btn.dart';
import '../onboarding.dart';

class OnboardingScreen1 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/onfirst.png", fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.80),
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 60,
              ).r,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Find Your Next\nFavorite Movie Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.3.h,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Get access to a huge library of movies to suit all tastes. You will surely like it.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey[200],
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
        ],
      ),
    );
  }
}
