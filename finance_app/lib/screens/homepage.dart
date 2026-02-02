import 'package:finance_app/components-services/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.graph_square_fill),
              label: 'Stats',
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.purple.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header("Budgii", "Dashboard", 20, Colors.purple.withOpacity(0.3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              displayCard(
                context: context,
                title: "Budget",
                amount: "₹25,000",
                //goToText: "Add Income",
                //appRoute: AppRoutes.addinc,
                backgroundColor: const Color.fromARGB(255, 241, 142, 223),
                //icon: Icons.arrow_upward,
                height: MediaQuery.of(context).size.width / 2 + 20,
                width: MediaQuery.of(context).size.width - 20,
              ),
              //displayCard(
              //context: context,
              //title: "Expense",
              //amount: "₹5,000",
              //goToText: "Add Expense",
              //appRoute: AppRoutes.addexp,
              //backgroundColor: const Color.fromARGB(255, 117, 147, 216),
              //icon: Icons.arrow_downward,
              //),
              // displayCard(

              //context: context,
              //title: "Budget",
              //amount: "₹25,000",
              //goToText: "Add Income",
              //appRoute: AppRoutes.addinc,
              //backgroundColor: const Color.fromARGB(255, 241, 142, 223),
              //icon: Icons.arrow_upward,
              // ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //on tap of view all it will show a list of transactions
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          //List view of all transactions
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Food",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                            ],
                          ),
                          Column(
                                children: [
                                  Text(
                                    "- RS.800",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "Today",
                                    style: TextStyle( 
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //appButton(context: context, label: 'Signout', routeName: AppRoutes.login)
          ElevatedButton(onPressed: (() => signOut()), child: Text("Sign Out")),
        ],
      ),
    );
  }
}
