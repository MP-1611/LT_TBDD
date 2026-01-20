import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../services/firebase_user_repository.dart';
import '../../../services/local_storage_service.dart';
import '../data/player_progress_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userRepo = FirebaseUserRepository();
  final _progressService = PlayerProgressService();

  String name = "";
  int weight = 0;
  String wakeUp = "";
  int dailyGoal = 0;
  String? avatarUrl;

  int streak = 0;
  int totalIntake = 0;

  int level = 1;
  int xp = 0;
  int xpToNext = 100;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _userRepo.fetchUserData();

    if (data == null) {
      setState(() => loading = false);
      return;
    }

    final profile = data['profile'] ?? {};
    final water = data['water'] ?? {};
    final stats = data['stats'] ?? {};
    final progress = await _progressService.getProgress();

    setState(() {
      name = profile['name'] ?? "User";
      weight = profile['weight'] ?? 0;
      wakeUp = profile['wakeUp'] ?? "--:--";
      dailyGoal = water['dailyGoal'] ?? 0;
      avatarUrl = profile['avatar'];


      streak = stats['streak'] ?? 0;
      totalIntake = stats['totalIntake'] ?? 0;

      // 🔥 QUAN TRỌNG: level là INT, KHÔNG phải map
      level = progress['level']!;
      xp = progress['xp']!;
      xpToNext = progress['xpToNext']!;
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  children: [
                    _profileHeader(),
                    const SizedBox(height: 24),
                    _quickStats(),
                    const SizedBox(height: 20),
                    _hydrationStats(),
                    const SizedBox(height: 20),
                    _levelProgress(),
                    const SizedBox(height: 24),
                    _settings(),
                    const SizedBox(height: 16),
                    _logout(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.home), // ⬅️ BACK HOME
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Profile",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF36E27B)),
              onPressed: () async {
                final changed = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
                if (changed == true) {
                  _loadProfile(); // reload data
                }
              },
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF36E27B).withOpacity(0.3),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF36E27B).withOpacity(0.2),
                    blurRadius: 16,
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 56,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : const AssetImage("assets/images/avatar.png") as ImageProvider,
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF36E27B),
              child:
              const Icon(Icons.water_drop, color: Colors.black, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
         Text(
          "Hydration Hero • Lvl $level",
          style: TextStyle(color: Color(0xFF9EB7A8)),
        ),
      ],
    );
  }

  Widget _quickStats() {
    return Row(
      children: [
        _StatPill(icon: Icons.monitor_weight, value: "$weight", unit: "kg"),
        SizedBox(width: 12),
        _StatPill(icon: Icons.wb_sunny, value: wakeUp, unit: ""),
        SizedBox(width: 12),
        _StatPill(
          icon: Icons.local_drink,
          value: "$dailyGoal",
          unit: "ml",
          highlight: true,
        ),
      ],
    );
  }

  Widget _hydrationStats() {
    final int safeDailyGoal = dailyGoal <= 0 ? 1 : dailyGoal;

    final double percent =
    (totalIntake / safeDailyGoal).clamp(0, 1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _InfoCard(
            icon: Icons.local_fire_department,
            title: "Streak",
            value: "$streak Days",
            color: Colors.orange,
          ),
          _InfoCard(
            icon: Icons.water_drop,
            title: "Total Intake",
            value: "${(totalIntake / 1000).toStringAsFixed(1)}L",
            color: const Color(0xFF36E27B),
            filled: true,
          ),
          _InfoCard(
            icon: Icons.donut_large,
            title: "Goal",
            value: "${(percent * 100).toInt()}%",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _levelProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CURRENT LEVEL",
                style: TextStyle(
                  color: Color(0xFF9EB7A8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$xp / $xpToNext XP",
                style: TextStyle(color: Color(0xFF9EB7A8)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children:  [
              Text(
                "$level",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Chip(
                label: Text("Pro"),
                backgroundColor: Color(0xFF36E27B),
                labelStyle: TextStyle(color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xpToNext <= 0 ? 0 : xp / xpToNext,
              minHeight: 10,
              backgroundColor: Colors.black26,
              valueColor:
              const AlwaysStoppedAnimation(Color(0xFF36E27B)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "SETTINGS",
            style: TextStyle(
              color: Color(0xFF9EB7A8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        _settingItem(
          icon: Icons.person,
          title: "Personal Details",
          subtitle: "Age, Weight, Wake-up Time",
          color: Colors.blue,
        ),
        _settingItem(
          icon: Icons.notifications,
          title: "Notifications",
          subtitle: "Reminders, Sound, Vibrate",
          color: Colors.purple,
        ),
        _unitsSetting(),
        _settingItem(
          icon: Icons.info,
          title: "About AquaMate",
          subtitle: "Version 2.4.0",
          color: Colors.grey,
          divider: false,
        ),
      ],
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool divider = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle:
            Text(subtitle, style: const TextStyle(color: Color(0xFF9EB7A8))),
            trailing:
            const Icon(Icons.chevron_right, color: Colors.white38),
            onTap: () {},
          ),
          if (divider)
            const Divider(height: 1, color: Colors.white10),
        ],
      ),
    );
  }

  Widget _unitsSetting() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.straighten, color: Colors.black),
              ),
              SizedBox(width: 12),
              Text(
                "Units",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                _UnitChip("ML", active: true),
                _UnitChip("OZ"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logout() {
    return TextButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        await LocalStorageService.clearAll();
        Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
                (_) => false,
            );
      },
      child: const Text(
        "Log Out",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ---------------- SMALL WIDGETS ----------------

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final bool highlight;

  const _StatPill({
    required this.icon,
    required this.value,
    required this.unit,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight
              ? const Color(0xFF36E27B).withOpacity(0.15)
              : const Color(0xFF1C2620),
          borderRadius: BorderRadius.circular(20),
          border: highlight
              ? Border.all(color: const Color(0xFF36E27B))
              : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                color: highlight
                    ? const Color(0xFF36E27B)
                    : const Color(0xFF9EB7A8)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: highlight ? const Color(0xFF36E27B) : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(unit, style: const TextStyle(color: Color(0xFF9EB7A8))),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool filled;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: filled ? color : const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: filled ? Colors.black26 : color.withOpacity(0.2),
            child: Icon(icon, color: filled ? Colors.black : color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: filled ? Colors.black87 : const Color(0xFF9EB7A8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: filled ? Colors.black : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  final String text;
  final bool active;

  const _UnitChip(this.text, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF36E27B) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : const Color(0xFF9EB7A8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
