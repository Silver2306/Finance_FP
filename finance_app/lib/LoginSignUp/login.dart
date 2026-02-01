import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hint: Text("Enter Email: ")),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hint: Text("Enter Password: ")),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: (() => signIn()), child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
