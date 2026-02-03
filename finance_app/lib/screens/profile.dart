import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/components-services/mywidgets.dart';
import 'package:finance_app/components-services/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    double budget = 0; // hardcoded budget for now
    TextEditingController budgetcontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 User Info
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.purple),
              title: Text(
                user?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user?.email ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),

            // 💰 Budget Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.purple.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      color: Colors.purple,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Monthly Budget: ₹$budget",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            inputField(
              controller: budgetcontroller,
              hintText: "Set/Update Budget",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                "Update Budget",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: (() => signOut()),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
