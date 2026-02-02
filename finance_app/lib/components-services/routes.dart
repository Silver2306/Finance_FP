import 'package:flutter/material.dart';

// Import screens
import '../screens/login.dart';
import '../screens/homepage.dart';
import '../screens/signup.dart';
import '../screens/addInc.dart';
import '../screens/addExp.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';
  static const String addinc = '/addInc';
  static const String addexp = '/addExp';



  // Route map
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    home: (context) => const Homepage(),
    signup: (context) => const SignUp(),
    addinc: (context) => const Addinc(),
    addexp: (context) => const Addexp()
  };
}
