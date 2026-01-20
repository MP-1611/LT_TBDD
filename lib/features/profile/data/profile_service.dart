import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../services/firebase_user_repository.dart';
import '../../../services/local_storage_service.dart';

class ProfileService {
  final _userRepo = FirebaseUserRepository();
  final _storage = FirebaseStorage.instance;

  /// Load profile (ưu tiên local → fallback firebase)
  Future<Map<String, dynamic>> loadProfile() async {
    final local = {
      'name': LocalStorageService.getGender(), // tạm name
      'weight': LocalStorageService.getWeight(),
      'wakeUp': LocalStorageService.getWakeUp(),
      'dailyGoal': LocalStorageService.getDailyGoal(),
    };

    final data = await _userRepo.fetchUserData();
    if (data == null) return local;

    return {
      'name': data['profile']?['name'] ?? 'User',
      'weight': data['profile']?['weight'] ?? 60,
      'wakeUp': data['profile']?['wakeUp'] ?? '07:00',
      'dailyGoal': data['water']?['dailyGoal'] ?? 2000,
      "avatar": data['avatar'],
    };
  }

  /// Save profile
  Future<void> saveProfile({
    required String name,
    required double weight,
    required String wakeUp,
    required int dailyGoal,
    String? avatarUrl,
  }) async {
    // 🔥 SAVE FIRESTORE
    await _userRepo.updateUserData({
      'profile.name': name,
      'profile.weight': weight.toInt(),
      'profile.wakeUp': wakeUp,
      'water.dailyGoal': dailyGoal,
      if (avatarUrl != null) "avatar": avatarUrl,
    });

    // 🔥 SAVE LOCAL (QUAN TRỌNG)
    await LocalStorageService.setWeight(weight);
    await LocalStorageService.setWakeUp(wakeUp);
    await LocalStorageService.setDailyGoal(dailyGoal);
  }
  Future<String> uploadAvatar(File file) async {
    final uid = _userRepo.uid;
    final ref = _storage.ref("avatars/$uid.jpg");

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
}
