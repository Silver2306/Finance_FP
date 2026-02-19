import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/components-services/mywidgets.dart';
import 'package:finance_app/components-services/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toastify_flutter/toastify_flutter.dart';

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

  bool _isLoading = false;
  final budgetController = TextEditingController();

  Future<void> _updateBudget() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await setBudget(amt: budgetController);

      if (!mounted) {
        ToastifyFlutter.success(
          context,
          message: "Budget updated successfully!",
          style: ToastStyle.flat,
          position: ToastPosition.top,
          duration: 5,
        );
      }

      if (context.mounted) {
        // Navigator.pop(context, true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) {
        return ToastifyFlutter.error(
          context,
          message: 'Failed to update budget: $e',
          position: ToastPosition.top,
          style: ToastStyle.flat,
          duration: 5,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color.fromARGB(255, 232, 215, 217),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 User Info
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 40,
                color: Color.fromARGB(255, 200, 125, 135),
              ),
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
              color: Color.fromARGB(255, 240, 196, 203),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.black54,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    StreamBuilder(
                      stream: db.ref("users/${user?.uid}/budget").onValue,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data?.snapshot.value != null) {
                          final budget = (snapshot.data!.snapshot.value as num)
                              .toDouble();
                          return Text("Budget: ₹${budget.toStringAsFixed(0)}");
                        }
                        return const Text("No budget set");
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            inputField(
              controller: budgetController,
              hintText: "Set/Update Budget",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isLoading ? null : _updateBudget,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Color.fromARGB(255, 200, 125, 135),
              ),
              child: const Text(
                "Update Budget",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (() => signOut()),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),

                backgroundColor: Color.fromARGB(255, 200, 125, 135),
              ),
              child: Text(
                "Sign Out",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
