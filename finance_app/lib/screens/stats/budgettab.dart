import 'package:finance_app/components-services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:toastify_flutter/toastify_flutter.dart';

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
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month; // 1-12

  final List<String> monthLabels = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    _loadPieData();
  }

  bool _hasShownOverBudgetToast = false;

  void _checkOverBudget() {
    if (_hasShownOverBudgetToast) return;

    if (expense > budget && budget > 0) {
      ToastifyFlutter.error(
        context,
        message: "You have exceeded your budget!",
        duration: 10,
        position: ToastPosition.top,
        style: ToastStyle.flatColored,
      );

      _hasShownOverBudgetToast = true;
    }
  }

  Future<void> _loadPieData() async {
    setState(() => isLoading = true);

    final data = await piegraph(year: selectedYear, month: selectedMonth);

    final fetchedBudget = data["budget"] ?? 0.0;
    final fetchedExpense = data["expense"] ?? 0.0;
    final fetchedBalance = data["balance"] ?? 0.0;

    final safeExpense = fetchedExpense < 0 ? 0.0 : fetchedExpense;
    final safeBalance = fetchedBalance < 0 ? 0.0 : fetchedBalance;

    double expPercent = 0;
    double balPercent = 0;

    // Calculate percentages ONLY if budget > 0
    if (fetchedBudget > 0) {
      expPercent = (safeExpense / fetchedBudget) * 100;
      balPercent = (safeBalance / fetchedBudget) * 100;
    }

    if (mounted) {
      setState(() {
        budget = fetchedBudget;
        expense = safeExpense;
        balance = safeBalance;
        expensePercent = expPercent;
        balancePercent = balPercent;
        isLoading = false;
      });
      _checkOverBudget();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 245, 240),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      //border: Border.all(color: Colors.black12),
                    ),
                    //child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedMonth,
                      isExpanded: true,
                      items: List.generate(12, (i) {
                        final m = i + 1;
                        return DropdownMenuItem(
                          value: m,
                          child: Text(monthLabels[i]),
                        );
                      }),
                      onChanged: (m) async {
                        if (m == null) return;
                        setState(() {
                          selectedMonth = m;
                          _hasShownOverBudgetToast = false;
                        });
                        await _loadPieData();
                      },
                    ),
                  ),
                ),

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
                              color: Color.fromARGB(149, 233, 4, 42), // Expense
                              radius: 45,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: balance,
                              color: Color.fromARGB(
                                207,
                                56,
                                172,
                                141,
                              ), // Balance
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
                      Color.fromARGB(149, 233, 4, 42),
                      "Expense",
                      expense.toStringAsFixed(0),
                      expensePercent,
                    ),
                    _legendItem(
                      Color.fromARGB(207, 56, 172, 141),
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

  Widget _legendItem(Color color, String label, String value, double percent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Text(
              "₹$value  •  ${percent.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
