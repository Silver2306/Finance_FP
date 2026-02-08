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
  double expensePercent = 0;
double balancePercent = 0;
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

  // Always calculate balance FIRST
  final double calculatedBalance =
      (fetchedBudget - fetchedExpense).clamp(0, double.infinity);

  double expPercent = 0;
  double balPercent = 0;

  // Calculate percentages ONLY if budget > 0
  if (fetchedBudget > 0) {
    expPercent = (fetchedExpense / fetchedBudget) * 100;
    balPercent = (calculatedBalance / fetchedBudget) * 100;
  }

  if (mounted) {
    setState(() {
      budget = fetchedBudget;
      expense = fetchedExpense;
      balance = calculatedBalance;
      expensePercent = expPercent;
      balancePercent = balPercent;
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
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
                              color: const Color(0xffFF6B6B), // Expense
                              radius: 45,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: balance,
                              color: const Color(0xff4ECDC4), // Balance
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

                const SizedBox(height: 24),

                // Legend
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _legendItem(
      const Color(0xffFF6B6B),
      "Expense",
      expense.toStringAsFixed(0),
      expensePercent,
    ),
    _legendItem(
      const Color(0xff4ECDC4),
      "Balance",
      balance.toStringAsFixed(0),
      balancePercent,
    ),
  ],
),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, String value,double percent) {
    
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
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            Text(
              "₹$value  •  ${percent.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
