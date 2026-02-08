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
          bottom: const TabBar(
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expense"),
              Tab(text: "Budget"),
            ],
          ),
        ),
        body: TabBarView(children: [Incometab(), Expensetab(),BudgetTab()]),
      ),
    );
  }
}
