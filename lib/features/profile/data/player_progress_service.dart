import 'package:h20_reminder/services/firebase_user_repository.dart';

class PlayerProgressService {
  final _userRepo = FirebaseUserRepository();


  int _xpForLevel(int level) {
    // Level càng cao càng khó
    return 100 + (level - 1) * 50;
  }

  Future<Map<String, int>> addXp(int gainedXp) async {
    final user = await _userRepo.fetchUserData();

    int level = user?['level'] ?? 1;
    int xp = user?['xp'] ?? 0;

    xp += gainedXp;

    int xpToNext = _xpForLevel(level);

    while (xp >= xpToNext) {
      xp -= xpToNext;
      level++;
      xpToNext = _xpForLevel(level);
    }

    await _userRepo.saveUserData({
      "level": level,
      "xp": xp,
    });

    return {
      "level": level,
      "xp": xp,
      "xpToNext": xpToNext,
    };
  }

  Future<Map<String, int>> getProgress() async {
    final user = await _userRepo.fetchUserData();
    final level = user?['level'] ?? 1;
    final xp = user?['xp'] ?? 0;

    return {
      "level": level,
      "xp": xp,
      "xpToNext": _xpForLevel(level),
    };
  }
}
