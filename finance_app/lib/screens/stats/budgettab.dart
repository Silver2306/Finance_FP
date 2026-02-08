import 'package:finance_app/components-services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

class _BudgetTabState extends State<BudgetTab> {
  double budget = 0;
  double expense = 0;
  double balance = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPieData();
  }

  Future<void> _loadPieData() async {
  final data = await fetchDashboardData();

  final fetchedBudget = data["budget"] ?? 0.0;
  final fetchedExpense = data["expense"] ?? 0.0;

  if (mounted) {
    setState(() {
      budget = fetchedBudget;
      expense = fetchedExpense;
      balance = (budget - expense).clamp(0, double.infinity);
      isLoading = false;
    });
  }
}

 @override
@override
Widget build(BuildContext context) {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pie Chart
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.width * 0.85,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 95,
                  sections: [
                    PieChartSectionData(
                      value: expense,
                      color: const Color(0xffFF6B6B),
                      radius: 45,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: balance,
                      color: const Color(0xff4ECDC4),
                      radius: 45,
                      showTitle: false,
                    ),
                  ],
                ),
              ),

              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Monthly Budget",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹${budget.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _legendItem(
              const Color(0xffFF6B6B),
              "Expense",
              expense.toStringAsFixed(0),
            ),
            _legendItem(
              const Color(0xff4ECDC4),
              "Balance",
              balance.toStringAsFixed(0),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _legendItem(Color color, String label, String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 6),
      Text(
        "$label: ₹$value",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
}