import 'package:flutter/material.dart';
import '../components-services/firebase_services.dart';
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
      appBar: AppBar(title: Text("Transactions Page")),
      body: RecentTransactions(limit: 6),
    );
  }
}
