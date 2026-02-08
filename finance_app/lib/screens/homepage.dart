import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/components-services/recentTransactions.dart';
import 'package:finance_app/components-services/routes.dart';
import 'package:finance_app/screens/transactionpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastify_flutter/toastify_flutter.dart';
import '../components-services/mywidgets.dart';
import '../screens/stats/statspage.dart';

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
  bool _hasShownOverBudgetWarning = false;
  @override
  void initState() {
    super.initState();

    dashboardFuture = fetchDashboardData();
  }

  void refreshDashboard() {
    setState(() {
      dashboardFuture = fetchDashboardData();
      _hasShownOverBudgetWarning = false;
    });
  }

  void _showOverBudgetToastIfNeeded(
    Map<String, double> data,
    BuildContext context,
  ) {
    if (_hasShownOverBudgetWarning) return;

    final expense = data["expense"] ?? 0;
    final budget = data["budget"] ?? 0;

    if (expense > budget && expense > 0 && budget > 0) {
      ToastifyFlutter.error(
        context,
        message: "Expenses exceeded budget!",
        duration: 5,
        position: ToastPosition.top,
        style: ToastStyle.flatColored,
      );

      _hasShownOverBudgetWarning = true;
    }
  }

  int index = 0;
  Color selectedColor = Colors.purple;
  Color unselectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(
          0.2,
        ), // or whatever color you like
        elevation: 0,
        title: Text(
          "Hello, ${user?.displayName ?? 'User'}", // Firebase name
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final result = Navigator.pushNamed(context, AppRoutes.profile);
              debugPrint('$result');
              if (result == true) {
                refreshDashboard();
              } // replace with your route
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

                              _showOverBudgetToastIfNeeded(data, context);

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
                const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RecentTransactions(limit: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Transactions(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Statspage(),
    );
  }
}
