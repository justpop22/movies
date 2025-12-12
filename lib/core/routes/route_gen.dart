import 'package:flutter/material.dart';
import 'package:movies/modules/home/pages/main_layout.dart';
import '../../modules/auth/pages/forget_password_screen.dart';
import '../../modules/auth/pages/login_screen.dart';
import '../../modules/auth/pages/register_screen.dart';
import '../../modules/onboarding/onboarding.dart';
import '../../modules/splash/pages/splash_screen.dart';
import 'app_route_name.dart';

class RouteGen {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SplashScreen();
          },
        );

      case RouteName.onBoarding:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnBoarding();
          },
        );

      case RouteName.login :
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return LoginScreen();
          },);

      case RouteName.register :
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return RegisterScreen();
          },);

      case RouteName.forgetPassword :
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return ForgetPasswordScreen();
          },);

        case RouteName.layout :
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return MainLayout();
          },);

      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return NotFoundScreen();
          },
        );
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
