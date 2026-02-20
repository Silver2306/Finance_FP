import 'dart:ui';

import 'package:finance_app/components-services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'stattile.dart';

class Incometab extends StatefulWidget {
  const Incometab({super.key});

  @override
  State<Incometab> createState() => _IncometabState();
}

class _IncometabState extends State<Incometab> {
  List<int> _dailyIncome = List.filled(7, 0);

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month; // 1-12

  @override
  void initState() {
    super.initState();
    _loadIncome();
  }

  Future<void> _loadIncome() async {
    final data = await barIncome(year: selectedYear, month: selectedMonth);
    if (mounted) {
      setState(() => _dailyIncome = data);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    maxY: 20000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = [
                              'Salary',
                              'Pocket Money',
                              'Investment',
                              'Gift',
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
                          interval: 5000, // 👈 spacing
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
                    barGroups: _dailyIncome
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
                child: incomeTile(),
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
          color: Colors.green,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
