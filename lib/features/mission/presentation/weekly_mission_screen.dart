import 'package:flutter/material.dart';
import 'package:h20_reminder/features/mission/presentation/widgets/exp_overlay.dart';
import '../../../routes/app_routes.dart';
import '../../profile/data/player_progress_service.dart';
import '../../profile/presentation/exp_bar.dart';
import '../data/weekly_mission_service.dart';
import '../models/mission_model.dart';

class WeeklyMissionScreen extends StatefulWidget {
  const WeeklyMissionScreen({super.key});

  @override
  State<WeeklyMissionScreen> createState() => _WeeklyMissionScreenState();
}

class _WeeklyMissionScreenState extends State<WeeklyMissionScreen> {
  final _service = WeeklyMissionService();

  int weeklyGoal = 14000;
  int weeklyCurrent = 0;
  int reachedDays = 0;
//EXP
  int level = 1;
  int xp = 0;
  int xpToNext = 100;
  bool showExpBar = false;
  final _progressService = PlayerProgressService();

  Future<void> _load() async {
    final now = DateTime.now();
    weeklyCurrent = await _service.getWeeklyTotal(now);
    reachedDays = await _service.getReachedDays(now);

    final p = await _progressService.getProgress();
    level = p['level']!;
    xp = p['xp']!;
    xpToNext = p['xpToNext']!;

    setState(() => loading = false);
  }

  bool loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }
  void _showExpTemporarily() {
    setState(() => showExpBar = true);

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => showExpBar = false);
    });
  }
  void showExpOverlay({
    required int level,
    required int xp,
    required int xpToNext,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => Stack(
        children: [
          ExpOverlay(
            level: level,
            currentXp: xp,
            xpToNext: xpToNext,
          ),
        ],
      ),
    );
  }



  double get weeklyProgress =>
      (weeklyCurrent / weeklyGoal).clamp(0, 1);

  List<Mission> get  missions => [
    Mission(
      id: "drink_5_days",
      title: "Drink 5 days/week",
      description: "Reward: +100 XP",
      icon: Icons.calendar_month,
      reward: 100,
      rewardType: "XP",
      progress: reachedDays / 5,
      status: reachedDays >= 5
          ? MissionStatus.completed
          : MissionStatus.active,
      color: Colors.blueAccent,
    ),
    Mission(
      id: "daily_goal",
      title: "Reach weekly goal",
      description: "Reward: +50 Drops",
      icon: Icons.local_drink,
      reward: 50,
      rewardType: "Drops",
      progress: weeklyProgress,
      status: weeklyProgress >= 1
          ? MissionStatus.completed
          : MissionStatus.active,
      color: Colors.purpleAccent,
    ),
    Mission(
      id: "streak",
      title: "Hydration Streak",
      description: "Task Completed!",
      icon: Icons.emoji_events,
      reward: 200,
      rewardType: "XP",
      progress: 1.0,
      status: MissionStatus.completed,
      color: const Color(0xFF36E27B),
    ),
    Mission(
      id: "workout",
      title: "Workout Hydration",
      description: "Unlock at Level 5",
      icon: Icons.fitness_center,
      reward: 0,
      rewardType: "",
      progress: 0,
      status: MissionStatus.locked,
      color: Colors.grey,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: SafeArea(
        child: loading
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF36E27B)),
        )
            : Column(
          children: [
            _appBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _weeklyCard(),
                    const SizedBox(height: 24),
                    const Text(
                      "⚡ Active Quests",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    ...missions.map(_missionCard),
                    const SizedBox(height: 24),
                    _sectionTitle("🔒 Locked Quests"),
                    ...missions
                        .where((m) => m.status == MissionStatus.locked)
                        .map(_missionCard),
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

  Widget _appBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.home), // ⬅️ BACK HOME
        ),
          Expanded(
            child: Center(
              child: Text(
                "Nhiệm vụ tuần",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Chip(
              label: Text("W1"),
              backgroundColor: Color(0xFF36E27B),
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
      ],
    );
  }

  Widget _headline() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Keep it flowing!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "You're doing great, maintain your hydration streak.",
                style: TextStyle(color: Color(0xFF9EB7A8)),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFF36E27B),
          child: Icon(Icons.water_drop, size: 40, color: Colors.black),
        ),
      ],
    );
  }

  Widget _weeklyCard() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weekly Goal",
                    style: TextStyle(color: Color(0xFF9EB7A8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$weeklyCurrent / $weeklyGoal ml",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: Color(0xFF36E27B),
                child: Icon(Icons.water_drop, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Progress", style: TextStyle(color: Color(0xFF9EB7A8))),
              Text("${(weeklyProgress * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),

          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: weeklyProgress,
            minHeight: 10,
            backgroundColor: Colors.black26,
            valueColor:
            const AlwaysStoppedAnimation(Color(0xFF36E27B)),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _missionCard(Mission m) {
    final locked = m.status == MissionStatus.locked;
    final completed = m.status == MissionStatus.completed;

    return Opacity(
      opacity: locked ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2620),
          borderRadius: BorderRadius.circular(20),
          border: completed
              ? Border.all(color: const Color(0xFF36E27B))
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: m.color.withOpacity(0.2),
                  child: Icon(m.icon, color: m.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        m.description,
                        style: TextStyle(
                          color: completed
                              ? const Color(0xFF36E27B)
                              : const Color(0xFF9EB7A8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showExpBar)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ExpBar(
                  level: level,
                  currentXp: xp,
                  xpToNext: xpToNext,
                ),
              ),
            const SizedBox(height: 12),
            if (m.status == MissionStatus.active)
              LinearProgressIndicator(
                value: m.progress,
                backgroundColor: Colors.black26,
                valueColor:
                AlwaysStoppedAnimation(m.color),
              ),
            if (completed)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF36E27B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    if (m.rewardType == "XP") {
                      _showExpTemporarily(); // 👈 quan trọng

                      final result = await _progressService.addXp(m.reward);

                      setState(() {
                        level = result['level']!;
                        xp = result['xp']!;
                        xpToNext = result['xpToNext']!;
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Nhận ${m.reward} ${m.rewardType}! 🎉"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text(
                    "Claim Reward +${m.reward} ${m.rewardType}",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
