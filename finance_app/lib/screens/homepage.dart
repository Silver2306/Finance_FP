import 'package:finance_app/components-services/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components-services/mywidgets.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

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
    return Scaffold(
      body: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header("Budgii", "Dashboard", 20,Colors.purple.withOpacity(0.3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                displayCard(
                  context: context,
                  title: "Income",
                  amount: "₹25,000",
                  goToText: "Add Income",
                  appRoute: AppRoutes.addinc,
                  backgroundColor: const Color.fromARGB(255, 241, 142, 223),
                  icon: Icons.arrow_upward,
                ),
                displayCard(
                  context: context,
                  title: "Expense",
                  amount: "₹5,000",
                  goToText: "Add Expense",
                  appRoute: AppRoutes.addexp,
                  backgroundColor: const Color.fromARGB(255, 117, 147, 216),
                  icon: Icons.arrow_downward,
                ),
                displayCard(

                  context: context,
                  title: "Budget",
                  amount: "₹25,000",
                  goToText: "Add Income",
                  appRoute: AppRoutes.addinc,
                  backgroundColor: const Color.fromARGB(255, 241, 142, 223),
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
            //appButton(context: context, label: 'Signout', routeName: AppRoutes.login)
            ElevatedButton(onPressed:  (() => signOut()), child: Text("Sign Out"))
          ],
      ),
    );
  }
}
