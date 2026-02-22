import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final db = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL:
      "https://finance-fp-default-rtdb.asia-southeast1.firebasedatabase.app/",
);

Future<void> addTransaction({
  required String type,
  required int amt,
  required String category,
  String? note,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }

  final ref = db.ref("users/${user.uid}/transactions").push();

  await ref.set({
    "type": type,
    "amount": amt,
    "category": category,
    "note": note,
    "timestamp": ServerValue.timestamp,
  });
}

Future<Map<String, double>> fetchDashboardData({
  required int year,
  required int month,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return {"budget": 0.0, "income": 0.0, "expense": 0.0};
  }

  final String uid = user.uid;
  final ref = db.ref("users/$uid");

  final DataSnapshot snapshot = await ref.get();

  if (!snapshot.exists || snapshot.value == null) {
    return {"budget": 0.0, "income": 0.0, "expense": 0.0};
  }

  final data = snapshot.value as Map<dynamic, dynamic>;

  // ---- Budget ----
  double budget = 0.0;
  final rawBudget = data["budget"];
  if (rawBudget is num) {
    budget = rawBudget.toDouble();
  } else if (rawBudget is String) {
    budget = double.tryParse(rawBudget) ?? 0.0;
  }

  final firstDayOfMonth = DateTime(year, month, 1);
  final firstDayOfNextMonth = DateTime(year, month + 1, 1);

  final startMs = firstDayOfMonth.millisecondsSinceEpoch;
  final endMs = firstDayOfNextMonth.millisecondsSinceEpoch - 1;

  // ── Monthly income & expense
  double monthlyIncome = 0.0;
  double monthlyExpense = 0.0;

  final transactionsRaw = data["transactions"];
  if (transactionsRaw is Map<dynamic, dynamic>) {
    for (final txValue in transactionsRaw.values) {
      if (txValue is! Map<dynamic, dynamic>) continue;

      final typeRaw = txValue["type"]?.toString().toLowerCase() ?? "";
      final amountRaw = txValue["amount"];
      final timestampRaw =
          txValue["timestamp"]; // ← assuming you store timestamp

      double amount = 0.0;
      if (amountRaw is num) {
        amount = amountRaw.toDouble();
      } else if (amountRaw is String) {
        amount = double.tryParse(amountRaw) ?? 0.0;
      }

      // Skip if no valid amount
      if (amount <= 0) continue;

      bool inSelectedMonth = false;
      if (timestampRaw is num) {
        final txTimeMs = timestampRaw.toInt();
        inSelectedMonth = txTimeMs >= startMs && txTimeMs <= endMs;
      }

      if (inSelectedMonth) {
        if (typeRaw == "income") {
          monthlyIncome += amount;
        } else if (typeRaw == "expense") {
          monthlyExpense += amount;
        }
      }
    }
  }
  return {"budget": budget, "income": monthlyIncome, "expense": monthlyExpense};
}

typedef TransactionSummary = ({
  String key,
  String category,
  double amount,
  String type, // "expense" or "income"
  DateTime date,
  String? note,
});

typedef Stats = ({
  String key,
  String category,
  double amount,
  String type, // "expense" or "income"
  DateTime date,
});

Future<List<TransactionSummary>> getTransaction({int limit = 5}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("No user");
    return [];
  }

  final userId = user.uid;
  final path = 'users/$userId/transactions';

  try {
    final ref = db.ref().child(path);

    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    final dataMap = snapshot.value as Map<dynamic, dynamic>;

    List<TransactionSummary> transactions = [];

    dataMap.forEach((key, value) {
      final txMap = value as Map<dynamic, dynamic>;

      final amount = (txMap['amount'] as num?)?.toDouble() ?? 0.0;
      final timestampMs = txMap['timestamp'] as num?;

      final date = timestampMs != null
          ? DateTime.fromMillisecondsSinceEpoch(timestampMs.toInt())
          : DateTime.now();

      final typeRaw = txMap['type'] as String? ?? 'expense';
      final type = typeRaw.toLowerCase();

      transactions.add((
        key: key as String,
        category: (txMap['category'] as String?)?.trim() ?? 'Other',
        amount: amount,
        type: type, // "expense" or "income"
        date: date,
        note: txMap['note'] as String?,
      ));
    });
    transactions.sort((a, b) => b.date.compareTo(a.date));

    if (limit > 0 && transactions.length > limit) {
      transactions = transactions.take(limit).toList();
    }

    return transactions;
  } catch (e, stack) {
    debugPrint('Error fetching transactions: $e\n$stack');
    return [];
  }
}

Future<void> setBudget({required double amt}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }
  final ref = db.ref("users/${user.uid}/budget");

  await ref.set(amt);
}

Future<Map<String, double>> getIncome({
  required int year,
  required int month,
  int limit = 50,
}) async {
  final transactionStats = await getTransaction(limit: limit);
  final incomeStats = <String, double>{};

  for (final t in transactionStats) {
    if (t.type == 'income') {
      if (t.date.year == year && t.date.month == month) {
        final cat = t.category;
        incomeStats[cat] = (incomeStats[cat] ?? 0) + t.amount;
      }
    }
  }

  return incomeStats;
}

Future<Map<String, double>> getExpense({
  required int year,
  required int month,
  int limit = 50,
}) async {
  final transactionStats = await getTransaction(limit: limit);
  final expenseStats = <String, double>{};

  for (final t in transactionStats) {
    if (t.type == 'expense') {
      if (t.date.year == year && t.date.month == month) {
        final cat = t.category;
        expenseStats[cat] = (expenseStats[cat] ?? 0) + t.amount;
      }
    }
  }

  return expenseStats;
}

Future<List<int>> barIncome({required int year, required int month}) async {
  final incomeStats = await getIncome(year: year, month: month, limit: 50);
  const categoriesOrder = [
    'Salary',
    'Pocket Money',
    'Investment',
    'Gift',
    'Misc',
  ];

  final List<int> values = List.filled(categoriesOrder.length, 0);

  for (final entry in incomeStats.entries) {
    final index = categoriesOrder.indexOf(entry.key);
    if (index != -1) {
      values[index] += entry.value.toInt();
    } else {
      // optional: add unknown categories to "Other"
      values.last += entry.value.toInt();
    }
  }

  return values;
}

Future<List<int>> barExpense({required int year, required int month}) async {
  final expenseStats = await getExpense(year: year, month: month, limit: 50);
  const categoriesOrder = [
    'Food',
    'Clothes',
    'Travel',
    'Gifts',  
    'Entertainment',
    'College',
    'Misc',
  ];

  final List<int> values = List.filled(categoriesOrder.length, 0);

  for (final entry in expenseStats.entries) {
    final index = categoriesOrder.indexOf(entry.key);
    if (index != -1) {
      values[index] += entry.value.toInt();
    } else {
      values.last += entry.value.toInt();
    }
  }

  return values;
}

Future<Map<String, double>> piegraph({
  required int year,
  required int month,
}) async {
  final stats = await fetchDashboardData(year: year, month: month);

  final budget = stats["budget"] ?? 0.0;
  final expense = stats["expense"] ?? 0.0;
  final balance = budget - expense;

  final barstats = <String, double>{};
  barstats['budget'] = budget;
  barstats['expense'] = expense;
  barstats['balance'] = balance;

  return barstats;
}

Future<void> deleteTransaction(String key) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  final userId = user.uid;
  final path = 'users/$userId/transactions/$key';

  await db.ref().child(path).remove();
}
