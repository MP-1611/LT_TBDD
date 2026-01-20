import 'package:intl/intl.dart';

import '../../water/data/water_log_repository.dart';
import '../../../services/firebase_user_repository.dart';

class WeeklyMissionService {
  final _waterRepo = WaterLogRepository();
  final _userRepo = FirebaseUserRepository();

  // =========================
  // 🔑 WEEK KEY
  // =========================
  String _weekKey(DateTime date) {
    final firstThursday =
    DateTime(date.year, 1, 4);
    final diff =
        date.difference(firstThursday).inDays;
    final week = (diff / 7).floor() + 1;
    return '${date.year}-W$week';
  }

  // =========================
  // 💧 TOTAL WATER THIS WEEK
  // =========================
  Future<int> getWeeklyTotal(DateTime date) async {
    final logs = await _waterRepo.getByWeek(date).first;

    return logs.fold<int>(
      0,
          (sum, log) => sum + log.amount,
    );
  }

  // =========================
  // 📅 DAYS REACHED DAILY GOAL
  // =========================
  Future<int> getReachedDays(DateTime date) async {
    final logs = await _waterRepo.getByWeek(date).first;

    final dailyMap = <String, int>{};

    for (final l in logs) {
      dailyMap[l.id] =
          (dailyMap[l.id] ?? 0) + l.amount;
    }

    final user = await _userRepo.fetchUserData();
    final dailyGoal =
        user?['water']?['dailyGoal'] ?? 2000;

    return dailyMap.values
        .where((v) => v >= dailyGoal)
        .length;
  }

  // =========================
  // 🧠 CHECK IF CLAIMED
  // =========================
  Future<bool> isMissionClaimed(String missionId) async {
    final user = await _userRepo.fetchUserData();
    final data = user?['missions']?['weekly']?[missionId];

    if (data == null) return false;

    final storedWeek = data['weekKey'];
    final currentWeek = _weekKey(DateTime.now());

    return storedWeek == currentWeek &&
        data['claimed'] == true;
  }

  // =========================
  // 🎁 CLAIM MISSION
  // =========================
  Future<void> claimMission({
    required String missionId,
    required int xp,
    required int drops,
  }) async {
    final weekKey = _weekKey(DateTime.now());

    await _userRepo.incrementStats(
      xp: xp,
      drops: drops,
    );

    await _userRepo.updateUserData({
      'missions.weekly.$missionId': {
        'claimed': true,
        'weekKey': weekKey,
      }
    });
  }

  // =========================
  // 🔓 LEVEL LOCK
  // =========================
  bool isUnlocked({
    required int playerLevel,
    required int requiredLevel,
  }) {
    return playerLevel >= requiredLevel;
  }

  // =========================
  // ♻️ RESET WEEKLY (AUTO)
  // =========================
  Future<void> resetIfNewWeek() async {
    final user = await _userRepo.fetchUserData();
    final missions = user?['missions']?['weekly'];

    if (missions == null) return;

    final currentWeek = _weekKey(DateTime.now());

    final updates = <String, dynamic>{};

    missions.forEach((key, value) {
      if (value['weekKey'] != currentWeek) {
        updates['missions.weekly.$key'] = null;
      }
    });

    if (updates.isNotEmpty) {
      await _userRepo.updateUserData(updates);
    }
  }
}
