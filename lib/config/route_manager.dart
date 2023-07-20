
import 'package:flutter/material.dart';
import 'package:magadh_tech/presentation/screens/landing_screen.dart';
import 'package:magadh_tech/presentation/screens/otp_screen.dart';
import 'package:magadh_tech/presentation/screens/phone_number_screen.dart';
import 'package:magadh_tech/presentation/screens/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String landingScreen = '/landingScreen';
  static const String phoneNoScreen = '/phoneNoScreen';
  static const String otpScreen = '/otpScreen';

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.landingScreen:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case Routes.phoneNoScreen:
        return MaterialPageRoute(builder: (_) => const PhoneNumberScreen());  
      case Routes.otpScreen:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
    
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("No Route Found"),
        ),
        body: const Center(
          child: Text("No Route Found"),
        ),
      ),
    );
  }
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
