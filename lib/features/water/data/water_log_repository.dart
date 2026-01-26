import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'water_log_model.dart';

class WaterLogRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 📂 Ref tới water_logs của user hiện tại
  CollectionReference<Map<String, dynamic>> _userLogs(String uid) {
    return _db.collection('users').doc(uid).collection('water_logs');
  }

  // ======================
  // 🔢 ISO WEEK NUMBER
  // ======================
  int weekNumber(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final firstThursday = DateTime(thursday.year, 1, 4);
    return ((thursday.difference(firstThursday).inDays) / 7).floor() + 1;
  }


  // ======================
  // ➕ ADD WATER LOG
  // ======================
  Future<void> addLog({
    required int amount,
    required String type,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();

    final dayKey = DateFormat('yyyy-MM-dd').format(now);
    final weekKey =
        '${now.year}-W${weekNumber(now).toString().padLeft(2, '0')}';
    final monthKey = DateFormat('yyyy-MM').format(now);

    await _userLogs(user.uid).add({
      'amount': amount,
      'type': type,
      'createdAt': Timestamp.fromDate(now),
      'dayKey': dayKey,
      'weekKey': weekKey,
      'monthKey': monthKey,
    });
  }

  // ======================
  // 📅 GET BY DAY
  // ======================
  Stream<List<WaterLog>> getByDay(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return _query(field: 'dayKey', value: key);
  }

  // ======================
  // 📆 GET BY WEEK
  // ======================
  Stream<List<WaterLog>> getByWeek(DateTime date) {
    final key =
        '${date.year}-W${weekNumber(date).toString().padLeft(2, '0')}';
    return _query(field: 'weekKey', value: key);
  }

  // ======================
  // 🗓 GET BY MONTH
  // ======================
  Stream<List<WaterLog>> getByMonth(DateTime date) {
    final key = DateFormat('yyyy-MM').format(date);
    return _query(field: 'monthKey', value: key);
  }

  // ======================
  // 🔍 CORE QUERY
  // ======================
  Stream<List<WaterLog>> _query({
    required String field,
    required String value,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _userLogs(user.uid)
        .where(field, isEqualTo: value)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map((doc) => WaterLog.fromDoc(doc)).toList(),
    );
  }
  Stream<int> watchTodayTotal() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return _userLogs(user.uid)
        .where('dayKey', isEqualTo: todayKey)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<int>(
        0,
            (sum, doc) => sum + (doc['amount'] as int),
      ),
    );
  }

}