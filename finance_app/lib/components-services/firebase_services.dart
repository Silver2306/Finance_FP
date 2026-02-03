import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final db = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL:
      "https://finance-fp-default-rtdb.asia-southeast1.firebasedatabase.app/",
);

Future<void> addTransaction({
  required String type,
  required int amt,
  required String category,
  String? note = "",
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

Future<Map<String, double>> fetchDashboardData() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return {"budget": 0.0, "income": 0.0, "expense": 0.0};
  }

  final String uid = user.uid;
  final ref = db.ref("users/$uid");

  //final uid = FirebaseAuth.instance.currentUser!.uid;
  //final userRef = FirebaseDatabase.instance.ref("users/$uid");

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

  final now = DateTime.now();
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

  final startMs = firstDayOfMonth.millisecondsSinceEpoch;
  final endMs = firstDayOfNextMonth.millisecondsSinceEpoch - 1; // inclusive

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

      // Check date (timestamp in ms)
      final ts = timestampRaw;
      bool isCurrentMonth = false;

      if (ts is num) {
        final txTimeMs = ts.toInt();
        isCurrentMonth = txTimeMs >= startMs && txTimeMs <= endMs;
      }

      if (isCurrentMonth) {
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

// Future<List<Map<String, dynamic>>> fetchData() async {
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   final refer = db.ref("users/${uid}/transactions");

//   final DataSnapshot snapshot = await refer.get();

//   if (!snapshot.exists || snapshot.value == null) {
//     return [];
//   }

//   final Map<String, dynamic> data = Map<String, dynamic>.from(
//     snapshot.value as Map,
//   );

//   return data.values.map((e) => Map<String, dynamic>.from(e)).toList();
// }
