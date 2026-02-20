import 'package:flutter/material.dart';
import 'expensetab.dart';
import 'incometab.dart';
import 'budgettab.dart';

class Statspage extends StatelessWidget {
  const Statspage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Statistics"),
          backgroundColor: const Color.fromARGB(255, 250, 245, 240),
          bottom: const TabBar(
            labelColor: //const Color.fromARGB(150, 248, 187, 208),
                Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: //const Color.fromARGB(150, 248, 187, 208),
                Colors.pink,
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expense"),
              Tab(text: "Budget"),
            ],
          ),
        ),
        body: TabBarView(children: [Incometab(), Expensetab(), BudgetTab()]),
      ),
    );
  }
}
