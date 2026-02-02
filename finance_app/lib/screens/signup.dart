import 'package:finance_app/components-services/mywidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastify_flutter/toastify_flutter.dart';
import '../components-services/routes.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

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
  }

  //Pushing data into firebase
  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      }
      ToastifyFlutter.error(
        context,
        message: message,
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
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header("Start Your Journey", "Create your account", 40),
            SizedBox(height: 10),
            inputField(
              controller: email,
              hintText: "Email ",
              prefixIcon: Icons.person,
            ),
            inputField(
              controller: password,
              hintText: "Enter Password",
              prefixIcon: Icons.password,
              obscureText: true,
            ),
            inputField(
              controller: confirmPassword,
              hintText: "Confirm Password",
              prefixIcon: Icons.password,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: (() => signUp()),

              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple.withOpacity(0.7),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            goToPage(
              context: context,
              actionText: "Sign In",
              routeName: AppRoutes.login,
              prefixText: "Already have an account? ",
            ),
          ],
        ),
      ),
    );
  }
}
