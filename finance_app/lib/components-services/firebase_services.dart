import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final db = FirebaseDatabase.instanceFor(
  databaseURL:
      "https://finance-fp-default-rtdb.asia-southeast1.firebasedatabase.app/",
  app: Firebase.app(),
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
