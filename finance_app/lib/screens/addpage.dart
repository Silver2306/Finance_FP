import 'package:flutter/material.dart';
import 'addInc.dart';
import 'addExp.dart';

class Addpage extends StatelessWidget {
  const Addpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Transactions"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Add Income"),
              Tab(text: "Add Expense"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Addinc(),
            Addexp(),
          ],
        ),
      ),
    );
  }
}
