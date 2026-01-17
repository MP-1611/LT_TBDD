import '../../water/data/water_log_repository.dart';
import '../../../services/firebase_user_repository.dart';

class WeeklyMissionService {
  final _waterRepo = WaterLogRepository();
  final _userRepo = FirebaseUserRepository();

  /// Tổng nước trong tuần
  Future<int> getWeeklyTotal(DateTime date) async {
    final logs = await _waterRepo.getByWeek(date).first;

    return logs.fold<int>(
      0,
          (sum, log) => sum + log.amount,
    );
  }

  /// Số ngày đạt daily goal trong tuần
  Future<int> getReachedDays(DateTime date) async {
    final logs = await _waterRepo.getByWeek(date).first;

    final map = <String, int>{};
    for (final l in logs) {
      map[l.id] = (map[l.id] ?? 0) + l.amount;
    }

    final user = await _userRepo.fetchUserData();
    final dailyGoal = user?['water']?['dailyGoal'] ?? 2000;

    return map.values.where((v) => v >= dailyGoal).length;
  }

  /// Cộng thưởng
  Future<void> claimReward({
    required int xp,
    required int drops,
  }) async {
    await _userRepo.incrementStats(xp: xp, drops: drops);
  }
}
