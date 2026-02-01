import 'package:flutter/material.dart';

// Import screens
import 'LoginSignUp/login.dart';
import 'Home/homepage.dart';
import 'LoginSignUp/signup.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';

  // Route map
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    home: (context) => const Homepage(),
    signup: (context) => const SignUp(),
  };
}
