import 'package:flutter/material.dart';
import '../components-services/recentTransactions.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions Page"),
        backgroundColor: const Color.fromARGB(150, 248, 187, 208),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              radius: const Radius.circular(10),
              thickness: 8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics:
                    const BouncingScrollPhysics(), 
                child: RecentTransactions(limit: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
