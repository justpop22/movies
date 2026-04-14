import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_btn.dart';
import '../onboarding.dart';

class OnboardingScreen2 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Image.asset("assets/images/onsecond.png", fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue.withOpacity(0.2),
                  const Color(0xff08425000).withOpacity(0.5),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius:  BorderRadius.only(
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
                      "Discover Movies",
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
                      "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
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
                              visible: current > 1,
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
