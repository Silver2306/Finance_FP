import 'package:finance_app/components-services/firebase_services.dart';
import 'package:finance_app/screens/stats/stattile.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Expensetab extends StatefulWidget {
  const Expensetab({super.key});

  @override
  State<Expensetab> createState() => _ExpensetabState();
}

class _ExpensetabState extends State<Expensetab> {
  List<double> _dailyExpense = List.filled(7, 0);
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month; // 1-12

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    final data = await barExpense(year: selectedYear, month: selectedMonth);
    if (mounted) {
      setState(() {
        _dailyExpense = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxVal = _dailyExpense.isEmpty
        ? 0
        : _dailyExpense.reduce((a, b) => a > b ? a : b);

    final double maxY = maxVal == 0 ? 1 : maxVal * 1.2;
    final double interval = (maxY / 5).ceilToDouble().clamp(1, double.infinity);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: Card(
              color: Color.fromARGB(255, 40, 40, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = [
                              'Food',
                              'Clothes',
                              'Travel',
                              'Gifts',
                              'Entertain',
                              'College',
                              'Misc',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < labels.length) {
                              return Text(
                                labels[value.toInt()],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: interval,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '₹${value.toInt()}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _dailyExpense
                        .asMap()
                        .entries
                        .map((e) => makeGroupData(e.key, e.value.toDouble()))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              radius: const Radius.circular(10),
              thickness: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics:
                    const BouncingScrollPhysics(), // nice feel on iOS/Android
                child: expenseTile(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color.fromARGB(255, 253, 109, 109),
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
