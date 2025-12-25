import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/firebase_user_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController {
  final AuthRepository _repo = AuthRepository();
  final FirebaseUserRepository _firebaseRepo =
  FirebaseUserRepository();

  /// -------- LOGIN EMAIL --------
  Future<void> loginEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _repo.loginWithEmail(email, password);
      await _syncUserData();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// -------- REGISTER EMAIL --------
  Future<void> registerEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _repo.registerWithEmail(email, password);
      await _syncUserData();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// -------- GOOGLE LOGIN --------
  Future<void> loginGoogle(BuildContext context) async {
    try {
      await _repo.signInWithGoogle();
      await _syncUserData();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// -------- FACEBOOK LOGIN --------
  Future<void> loginFacebook(BuildContext context) async {
    try {
      await _repo.signInWithFacebook();
      await _syncUserData();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// -------- SYNC FIREBASE -> LOCAL --------
  Future<void> _syncUserData() async {
    final data = await _firebaseRepo.fetchUserData();
    if (data == null) return;

    final profile = data['profile'];
    final water = data['water'];
    final level = data['level'];

    if (profile != null) {
      await LocalStorageService.setWeight(
          (profile['weight'] ?? 60).toDouble());
      await LocalStorageService.setGender(
          profile['gender'] ?? 'male');
      await LocalStorageService.setWakeUp(
          profile['wakeUp'] ?? '07:00');
    }

    if (water != null) {
      await LocalStorageService.setDailyGoal(
          water['dailyGoal'] ?? 2000);
      await LocalStorageService.setCurrentWater(
          water['current'] ?? 0);
    }

    if (level != null) {
      await LocalStorageService.setLevel(level['level'] ?? 1);
      await LocalStorageService.setXP(level['xp'] ?? 0);
      await LocalStorageService.setDrops(level['drops'] ?? 0);
    }

    if (data['interests'] != null) {
      await LocalStorageService.setInterests(
        List<String>.from(data['interests']),
      );
    }
  }

  /// -------- NAVIGATION --------
  void _goNext(BuildContext context) {
    final hasWeight = LocalStorageService.getWeight() > 0;
    final hasInterests =
        LocalStorageService.getInterests().isNotEmpty;

    if (!hasWeight) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.personalInfo);
    } else if (!hasInterests) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.interests);
    } else {
      Navigator.pushReplacementNamed(
          context, AppRoutes.home);
    }
  }


  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

