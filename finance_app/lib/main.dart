import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'components-services/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initial = AppRoutes.login;

    if (FirebaseAuth.instance.currentUser != null) {
      initial = AppRoutes.home;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      initialRoute: initial,
      routes: AppRoutes.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 250, 245, 240),
      ),
    );
  }
}
