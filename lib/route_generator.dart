import 'package:flutter/material.dart';
import 'package:tclearpartner/src/app.dart';
import 'package:tclearpartner/src/resources/login_signup/change_password.dart';
import 'package:tclearpartner/src/resources/login_signup/login.dart';
import 'package:tclearpartner/src/resources/login_signup/sign_up.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
        case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/app':
        return MaterialPageRoute(builder: (_) => App());
      case '/change_pass':
        return MaterialPageRoute(
            builder: (_) => ChangePassword(args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
