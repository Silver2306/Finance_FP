import 'package:finance_app/components-services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper to format date nicely
String _formatDate(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Today';
  }
  if (date.year == now.year &&
      date.month == now.month &&
      date.day == now.day - 1) {
    return 'Yesterday';
  }
  return DateFormat('d MMM').format(date);
}

class RecentTransactions extends StatelessWidget {
  final int limit; // ← add this

  const RecentTransactions({
    super.key,
    this.limit = 3, // default to 3 if not specified
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<TransactionSummary>>(
        future: getTransaction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error loading transactions\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            );
          }

          final transactions = snapshot.data?.take(limit) ?? [];

          if (transactions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No recent transactions',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return Column(
            children: transactions.map((tx) {
              final isExpense = tx.type.toLowerCase() == 'expense';
              final sign = isExpense ? '-' : '+';
              final color = isExpense
                  ? Colors.red.shade700
                  : Colors.green.shade700;
              final displayAmount = tx.amount; // your DB keeps amount positive

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     Container(
                        //       width: 50,
                        //       height: 50,
                        //       child: Icon(Icons.currency_rupee_outlined),
                        //     ),
                        //     SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (tx.note != null && tx.note!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  tx.note!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        //],
                        //),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "$sign${NumberFormat('#,##0', 'en_IN').format(displayAmount)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: color,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _formatDate(tx.date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
