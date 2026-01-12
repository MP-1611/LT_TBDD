import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../notification/data/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../reminder/presentation/water_schedule_screen.dart';
import '../data/water_log_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentWater = 1250;
  int dailyGoal = 2000;
  final _notificationRepo = NotificationRepository();
  final _waterRepo = WaterLogRepository();

  double get progress => min(currentWater / dailyGoal, 1);

  void addWater(int amount) async {
    setState(() {
      currentWater += amount;
      if (currentWater > dailyGoal) {
        currentWater = dailyGoal;
      }
    });
    await _waterRepo.addLog(
      amount: amount,
      type: 'water',
    );
    await _notificationRepo.addNotification(
      title: 'Uống nước 💧',
      body: 'Bạn vừa uống thêm $amount ml nước',
    );
  }

  String get motivationText {
    if (progress < 0.3) {
      return "Let's get started 💧";
    } else if (progress < 0.7) {
      return "Great job! Keep it flowing!";
    } else {
      return "Almost there! 💪";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          _backgroundGlow(),
          SafeArea(
            child: Column(
              children: [
                _header(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
                    child: Column(
                      children: [
                        _motivation(),
                        const SizedBox(height: 24),
                        _progressSection(),
                        const SizedBox(height: 40),
                        _quickAdd(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _bottomNav(),
        ],
      ),
    );
  }

  // ---------------- UI PARTS ----------------

  Widget _backgroundGlow() {
    return Stack(
      children: [
        Positioned(
          top: -200,
          left: -200,
          child: _glow(const Color(0xFF36E27B).withOpacity(0.1), 400),
        ),
        Positioned(
          bottom: -200,
          right: -200,
          child: _glow(const Color(0xFF36E27B).withOpacity(0.05), 500),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// ☰ MENU
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),

              /// TITLE
              const Text(
                "Nhắc nhở uống nước",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// 🔔 NOTIFICATION
              StreamBuilder<int>(
                stream: _notificationRepo.unreadCount(),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.notifications,
                          );
                        },
                      ),
                      if (count > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }



  Widget _motivation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.thumb_up, color: Color(0xFF36E27B)),
          const SizedBox(width: 8),
          Text(
            motivationText,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _progressSection() {
    return Column(
      children: [
        Image.asset(
          "assets/images/mascot_home.png",
          width: 120,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 22,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF36E27B),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${currentWater.toString().replaceAllMapped(RegExp(r'(\\d)(?=(\\d{3})+(?!\\d))'), (m) => '${m[1]},')} ml",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Mục tiêu: $dailyGoal ml",
                    style: const TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "⚡ Quick Add",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _quickButton("+200ml", "Cup", Icons.local_cafe, 200),
            const SizedBox(width: 12),
            _quickButton("+300ml", "Glass", Icons.water, 300),
            const SizedBox(width: 12),
            _quickButton("+500ml", "Bottle", FontAwesomeIcons.bottleWater, 500),
          ],
        ),
      ],
    );
  }

  Widget _quickButton(
      String title, String subtitle, IconData icon, int value) {
    return Expanded(
      child: GestureDetector(
        onTap: () => addWater(value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2E24),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF36E27B),
                child: Icon(icon, color: Colors.black),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F1F16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(color: Colors.white24),

            ListTile(
              leading: const Icon(Icons.alarm, color: Color(0xFF36E27B)),
              title: const Text(
                "Đặt lịch uống nước",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context); // đóng drawer
                Navigator.pushNamed(context, AppRoutes.waterSchedule);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Color(0xFF36E27B)),
              title: const Text(
                "Lịch sử uống nước",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.waterHistory);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1612),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home,
              active: true,
              onTap: () {
              },
            ),
            _NavItem(
              icon: Icons.calendar_month,
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.missions);
              },
            ),
            _NavItem(
              icon: Icons.checklist,
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.shop);
              },
            ),
            _NavItem(
              icon: Icons.person,
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.profile);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 56,
        height: 48,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF36E27B) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: active ? Colors.black : Colors.white54,
        ),
      ),
    );
  }
}

