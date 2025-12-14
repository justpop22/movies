import 'package:flutter/material.dart';
import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_btn.dart';
import '../onboarding.dart';

class OnboardingScreen6 extends StatelessWidget {
  final PageController controller;

  const OnboardingScreen6({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Image.asset("assets/images/1917.png", fit: BoxFit.cover),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              child: Container(
                color: Color(0xff121312),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Start Watching Now",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 32),

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
                            SizedBox(height: 10),

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
