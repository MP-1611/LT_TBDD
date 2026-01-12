import 'package:cloud_firestore/cloud_firestore.dart';

class WaterLog {
  final String id;
  final int amount; // ml
  final DateTime time;
  final String type; // water, tea, coffee

  WaterLog({
    required this.id,
    required this.amount,
    required this.time,
    required this.type,
  });

  factory WaterLog.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WaterLog(
      id: doc.id,
      amount: data['amount'],
      type: data['type'],
      time: (data['time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'time': Timestamp.fromDate(time),
    };
  }
}
