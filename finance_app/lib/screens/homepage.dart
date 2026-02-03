import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/components-services/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify_flutter/toastify_flutter.dart';
import '../components-services/mywidgets.dart';
import '../screens/stats/statspage.dart';
import '../screens/addpage.dart';

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

  Future<Map<String, double>>? dashboardFuture;

  @override
  void initState() {
    super.initState();

    dashboardFuture = fetchDashboardData();
  }

  void refreshDashboard() {
    setState(() {
      dashboardFuture = fetchDashboardData();
    });
  }

  int index = 0;
  Color selectedColor = Colors.purple;
  Color unselectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.2), // or whatever color you like
        elevation: 0,
        title: Text(
          "Hello, ${user?.displayName ?? 'User'}", // Firebase name
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.profile,
              ); // replace with your route
            },
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: index == 0 ? selectedColor : unselectedColor,
              ),

              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.graph_square_fill,
                color: index == 1 ? selectedColor : unselectedColor,
              ),
              label: 'Stats',
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addpage);
        },
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

      body: index == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //  header(
                //  "Budgii",
                  //"Dashboard",
                  //20,
                //  Colors.purple.withOpacity(0.3),
                //),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RefreshIndicator(
                      onRefresh: () async => refreshDashboard(),
                      child: FutureBuilder<Map<String, double>>(
                        future: dashboardFuture,
                        builder:
                            (
                              BuildContext context,
                              AsyncSnapshot<Map<String, double>> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                ToastifyFlutter.error(
                                  context,
                                  message: snapshot.error.toString(),
                                  position: ToastPosition.top,
                                  style: ToastStyle.flat,
                                );
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }

                              final data = snapshot.data;
                              if (data == null) {
                                return const Center(
                                  child: Text("No data available"),
                                );
                              }

                              final budget = data["budget"] ?? 0.0;
                              final income = data["income"] ?? 0.0;
                              final expense = data["expense"] ?? 0.0;
                              final balance = budget - expense;

                              return displayCard(
                                context: context,
                                title: "Budget",
                                amount: "₹${budget.toStringAsFixed(2)}",
                                //goToText: "Add Income",
                                //appRoute: AppRoutes.addinc,
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  241,
                                  142,
                                  223,
                                ),
                                //icon: Icons.arrow_upward,
                                height:
                                    MediaQuery.of(context).size.width / 2 + 20,
                                width: MediaQuery.of(context).size.width - 20,
                                inctotal: income,
                                exptotal: expense,
                              );
                            },
                      ),
                    ),
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

                //const SizedBox(height: 5),

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
                                      child: Icon(
                                        Icons.currency_rupee_outlined,
                                      ),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.yellow,
                                      //   shape: BoxShape.circle,
                                      // ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Food",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onBackground,
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
                ElevatedButton(
                  onPressed: (() => signOut()),
                  child: Text("Sign Out"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addinc);
                  },
                  child: Text("Add Income"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addexp);
                  },
                  child: Text("Add Expense"),
                ),
              ],
            )
          : Statspage(),
    );
  }
}
