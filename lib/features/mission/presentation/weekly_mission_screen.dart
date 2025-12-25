import 'package:flutter/material.dart';
import '../models/mission_model.dart';

class WeeklyMissionScreen extends StatefulWidget {
  const WeeklyMissionScreen({super.key});

  @override
  State<WeeklyMissionScreen> createState() => _WeeklyMissionScreenState();
}

class _WeeklyMissionScreenState extends State<WeeklyMissionScreen> {
  int weeklyCurrent = 12500;
  int weeklyGoal = 14000;

  final List<Mission> missions = [
    Mission(
      id: "drink_5_days",
      title: "Drink 5 days/week",
      description: "Reward: +100 XP",
      icon: Icons.calendar_month,
      reward: 100,
      rewardType: "XP",
      progress: 0.6,
      status: MissionStatus.active,
      color: Colors.blueAccent,
    ),
    Mission(
      id: "daily_goal",
      title: "Reach daily goal",
      description: "Reward: +50 Drops",
      icon: Icons.local_drink,
      reward: 50,
      rewardType: "Drops",
      progress: 0.9,
      status: MissionStatus.active,
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

  double get weeklyProgress => weeklyCurrent / weeklyGoal;

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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headline(),
                    const SizedBox(height: 24),
                    _weeklyCard(),
                    const SizedBox(height: 28),
                    _sectionTitle("⚡ Active Quests"),
                    ...missions
                        .where((m) => m.status != MissionStatus.locked)
                        .map(_missionCard),
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

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: const [
          BackButton(color: Colors.white),
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
              label: Text("W12"),
              backgroundColor: Color(0xFF36E27B),
              labelStyle: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
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
                  onPressed: () {
                    // TODO: cộng XP / Drops
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
