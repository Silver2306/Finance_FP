import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastify_flutter/toastify_flutter.dart';
import '../components-services/routes.dart';
import '../components-services/mywidgets.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> signIn() async {
    // Email validation
    if (!isValidEmail(email.text.trim())) {
      ToastifyFlutter.error(
        context,
        message: 'Please enter a valid email address',
        duration: 5,
        position: ToastPosition.top,
        style: ToastStyle.flatColored,
      );
      return; // stop execution
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      ToastifyFlutter.error(
        context,
        message: 'Invalid username or password',
        duration: 5,
        position: ToastPosition.top,
        style: ToastStyle.flatColored,
        onClose: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color.fromARGB(255, 200, 125, 135),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(
              "Welcome Back",
              "Enter your details to login",
              40,
              Colors.transparent,
            ),
            SizedBox(height: 10),
            inputField(
              controller: email,
              hintText: "Email ",
              prefixIcon: Icons.person,
            ),
            inputField(
              controller: password,
              hintText: "Password",
              prefixIcon: Icons.password,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: (() => signIn()),

              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromARGB(255, 200, 125, 135),
              ),
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            goToPage(
              context: context,
              actionText: "Sign up ",
              routeName: AppRoutes.signup,
              prefixText: "Dont have an account? ",
            ),
          ],
        ),
      ),
    );
  }
}
