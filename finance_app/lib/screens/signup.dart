import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/components-services/mywidgets.dart';
import 'package:firebase_database/firebase_database.dart';
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
  TextEditingController name = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z]+\s+[a-zA-Z]+$');
    return nameRegex.hasMatch(name);
  }

  //Pushing data into firebase
  Future<void> signUp() async {
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

    if (!isValidName(name.text.trim())) {
      ToastifyFlutter.error(
        context,
        message: "Pleaase enter a valid name",
        duration: 5,
        position: ToastPosition.top,
        style: ToastStyle.flat,
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) {
        throw Exception("User creation failed");
      }

      await db.ref("users/${user.uid}").set({
        "name": name.text.trim(),
        "email": email.text.trim(),
        "createdAt": ServerValue.timestamp,
      });

      await user.updateDisplayName(name.text.trim());

      if (context.mounted) {
        ToastifyFlutter.success(
          context,
          message: "Account created successfully!",
          position: ToastPosition.top,
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'User creation failed') {
        message = "User creation failed, Please try again!";
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
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: const Color.fromARGB(150, 248, 187, 208),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(
              "Start Your Journey",
              "Create your account",
              35,
              Colors.transparent,
            ),
            SizedBox(height: 5),
            inputField(
              controller: name,
              hintText: "Full Name ",
              prefixIcon: Icons.person,
            ),
            inputField(
              controller: email,
              hintText: "Email ",
              prefixIcon: Icons.email_outlined,
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

                backgroundColor: const Color.fromARGB(150, 248, 187, 208),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(fontSize: 20, color: Colors.black),
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
