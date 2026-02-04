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
        Navigator.pushNamed(context, AppRoutes.home);
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
                      Icons.currency_rupee_rounded,
                      color: Colors.purple,
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
                    // Text(
                    //   "Monthly Budget: ₹$budget",
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            inputField(
              controller: budgetController,
              hintText: "Set/Update Budget",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.currency_rupee_rounded,
            ),

            ElevatedButton(
              onPressed: _isLoading ? null : _updateBudget,
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
