import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/notification/presentation/notification_screen.dart';
import '../features/onboarding/presentation/personal_info_screen.dart';
import '../features/onboarding/presentation/interest_screen.dart';
import '../features/onboarding/presentation/water_result_screen.dart';
import '../features/reminder/presentation/water_schedule_screen.dart';
import '../features/water/presentation/home_screen.dart';
import '../features/mission/presentation/weekly_mission_screen.dart';
import '../features/shop/presentation/shop_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/water/presentation/water_history_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(const LoginScreen());

      case AppRoutes.personalInfo:
        return _page(const PersonalInfoScreen());

      case AppRoutes.interests:
        return _page(const InterestScreen());

      case AppRoutes.waterResult:
        final args = settings.arguments as Map<String, dynamic>;
        return _page(
          WaterResultScreen(
            weight: args['weight'],
            activityMultipliers: args['multipliers'],
            dailyGoal: args['dailyGoal'],
          ),
        );
      case AppRoutes.notifications:
        return _page(const NotificationScreen());
      case AppRoutes.waterSchedule:
        return _page(const WaterScheduleScreen());
      case AppRoutes.waterHistory:
        return _page(const WaterHistoryScreen());

      case AppRoutes.home:
        return _page(const HomeScreen());

      case AppRoutes.missions:
        return _page(const WeeklyMissionScreen());

      case AppRoutes.shop:
        return _page(const ShopScreen());

      case AppRoutes.profile:
        return _page(const ProfileScreen());

      default:
        return _page(const LoginScreen());
    }
  }

  static PageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
