import 'package:flutter/material.dart';
import '../../../core/utils/water_calculator.dart';
import 'package:h20_reminder/services/local_storage_service.dart';
import 'package:h20_reminder/services/firebase_user_repository.dart';
import 'package:h20_reminder/routes/app_routes.dart';

class WaterResultScreen extends StatelessWidget {
  final double weight;
  final List<double> activityMultipliers;
  final int dailyGoal;

  const WaterResultScreen({
    super.key,
    required this.weight,
    required this.activityMultipliers,
    required this.dailyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final firebaseRepo = FirebaseUserRepository();
    final totalWater = calculateDailyWater(
      weightKg: weight,
      multipliers: activityMultipliers,
    );

    final liter = (totalWater / 1000).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              /// Title
              const Text(
                "Lượng nước\nphù hợp cho bạn",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 32),

              /// Water Circle
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF36E27B),
                      Color(0xFF2ED66E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF36E27B).withOpacity(0.4),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$liter L",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${totalWater.toInt()} ml / ngày",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2C22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Dựa trên cân nặng và các hoạt động hằng ngày của bạn, AquaMate đề xuất lượng nước này để giúp bạn tỉnh táo, khỏe mạnh và duy trì hiệu suất tốt nhất 💧",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              /// CTA
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF36E27B),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final goal = dailyGoal;

                  // LOCAL (để load nhanh)
                  await LocalStorageService.setDailyGoal(goal);

                  // Lưu firebase
                  await firebaseRepo.saveUserData({
                    "water": {
                      "dailyGoal": dailyGoal,
                    },
                    "onboardingDone": true,
                  });
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                        (route) => false,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Bắt đầu hành trình",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
