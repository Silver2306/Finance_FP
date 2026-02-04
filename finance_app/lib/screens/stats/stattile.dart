import 'package:flutter/material.dart';
import '../../components-services/firebase_services.dart';

class expenseTile extends StatelessWidget {
  const expenseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, double>>(
        future: getExpense(),
        builder: (context, snapshot) {
          final summary = snapshot.data ?? {};
          if (summary.isEmpty) return Text("No expense yet");

          final total = summary.values.fold(0.0, (a, b) => a + b);

          return Column(
            children: [
              Text(
                "Total Expense: ₹${total.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 28, color: Colors.red),
              ),
              ...summary.entries.map(
                (e) => ListTile(
                  leading: Icon(Icons.arrow_downward, color: Colors.red),
                  title: Text(e.key),
                  trailing: Text("₹${e.value.toStringAsFixed(0)}"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class incomeTile extends StatelessWidget {
  const incomeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Map<String, double>>(
        future: getIncome(),
        builder: (context, snapshot) {
          final summary = snapshot.data ?? {};
          if (summary.isEmpty) return Text("No income yet");

          final total = summary.values.fold(0.0, (a, b) => a + b);

          return Column(
            children: [
              Text(
                "Total Income: ₹${total.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 28, color: Colors.green),
              ),
              ...summary.entries.map(
                (e) => ListTile(
                  leading: const Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text(e.key),
                  trailing: Text("₹${e.value.toStringAsFixed(0)}"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
