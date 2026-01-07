
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';
import 'local_storage_service.dart';

class AppStartupService {
  static Future<String> getInitialRoute() async {
    final user = FirebaseAuth.instance.currentUser;

    // 1️⃣ Chưa login
    if (user == null) {
      return AppRoutes.login;
    }

    // 2️⃣ Đã login → load data
    final hasWeight = LocalStorageService.getWeight() > 0;
    final hasInterests = LocalStorageService.getInterests().isNotEmpty;
    final hasDailyGoal = LocalStorageService.getDailyGoal() > 0;

    // 3️⃣ Chưa onboarding
    if (!hasWeight) {
      return AppRoutes.personalInfo;
    }

    if (!hasInterests) {
      return AppRoutes.interests;
    }

    if (!hasDailyGoal) {
      return AppRoutes.waterResult;
    }

    // 4️⃣ Done → Home
    return AppRoutes.navigation;
  }
}

