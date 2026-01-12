import 'package:cloud_firestore/cloud_firestore.dart';

class WaterLog {
  final String id;
  final int amount;
  final String type;
  final DateTime createdAt;

  WaterLog({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory WaterLog.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return WaterLog(
      id: doc.id,
      amount: data['amount'] ?? 0,
      type: data['type'] ?? 'water',

      // ✅ FIX LỖI "Null is not a subtype of Timestamp"
      createdAt: (data['createdAt'] as Timestamp?)?.toDate()
          ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}