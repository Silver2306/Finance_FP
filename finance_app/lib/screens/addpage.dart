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
          backgroundColor: const Color.fromARGB(150, 248, 187, 208),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: "Add Income"),
              Tab(text: "Add Expense"),
            ],
          ),
        ),
        body: const TabBarView(children: [Addinc(), Addexp()]),
      ),
    );
  }
}
