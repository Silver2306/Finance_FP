import 'package:flutter/material.dart';
import 'incometab.dart';
import 'expensetab.dart';

class Statspage extends StatelessWidget {
  const Statspage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Statistics"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expense"),
            ],
          ),
        ),
        body: const TabBarView(children: [IncomeTab(), ExpenseTab()]),
      ),
    );
  }
}
