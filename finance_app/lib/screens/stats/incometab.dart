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

  @override
  void initState() {
    super.initState();
    _loadIncome();
  }

  Future<void> _loadIncome() async {
    final data = await barIncome(); // ← your function from earlier
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
              color: const Color(0xff2c4260),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10000,
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
                          // (value, meta) {
                          //   switch (value.toInt()) {
                          //     case 0:
                          //       return const Text(
                          //         'Mn',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 1:
                          //       return const Text(
                          //         'Te',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 2:
                          //       return const Text(
                          //         'Wd',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 3:
                          //       return const Text(
                          //         'Tu',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 4:
                          //       return const Text(
                          //         'Fr',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 5:
                          //       return const Text(
                          //         'St',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     case 6:
                          //       return const Text(
                          //         'Sn',
                          //         style: TextStyle(color: Colors.white),
                          //       );
                          //     default:
                          //       return const Text('');
                          //   }
                          // },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2000, // 👈 spacing
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
                    //   [makeGroupData(0, 8000),
                    //   makeGroupData(1, 1000),
                    //   makeGroupData(2, 1400),
                    //   makeGroupData(3, 1500),
                    //   makeGroupData(4, 1300),
                    //   makeGroupData(5, 1000),
                    //   makeGroupData(6, 1600),
                    // ],
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
          color: Colors.lightBlueAccent,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
