import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeTab extends StatelessWidget {
  const IncomeTab({super.key});

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Mn',
                                style: TextStyle(color: Colors.white),
                              );
                            case 1:
                              return const Text(
                                'Te',
                                style: TextStyle(color: Colors.white),
                              );
                            case 2:
                              return const Text(
                                'Wd',
                                style: TextStyle(color: Colors.white),
                              );
                            case 3:
                              return const Text(
                                'Tu',
                                style: TextStyle(color: Colors.white),
                              );
                            case 4:
                              return const Text(
                                'Fr',
                                style: TextStyle(color: Colors.white),
                              );
                            case 5:
                              return const Text(
                                'St',
                                style: TextStyle(color: Colors.white),
                              );
                            case 6:
                              return const Text(
                                'Sn',
                                style: TextStyle(color: Colors.white),
                              );
                            default:
                              return const Text('');
                          }
                        },
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
                  barGroups: [
                    makeGroupData(0, 8000),
                    makeGroupData(1, 1000),
                    makeGroupData(2, 1400),
                    makeGroupData(3, 1500),
                    makeGroupData(4, 1300),
                    makeGroupData(5, 1000),
                    makeGroupData(6, 1600),
                  ],
                ),
              ),
            ),
                    ),
          ),
        const SizedBox(height: 16),

          // 🔽 LIST BELOW CHART
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading:
                      Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text('Salary'),
                  trailing: Text(
                    '₹5000',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading:
                      Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text('Freelance'),
                  trailing: Text(
                    '₹2000',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading:
                      Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text('Bonus'),
                  trailing: Text(
                    '₹1500',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
