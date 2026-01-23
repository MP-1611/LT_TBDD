import 'package:flutter/material.dart';

import '../../../services/firebase_user_repository.dart';
import '../../../services/notification_service.dart';
import '../data/water_reminder_service.dart';

class WaterScheduleScreen extends StatefulWidget {
  const WaterScheduleScreen({super.key});

  @override
  State<WaterScheduleScreen> createState() => _WaterScheduleScreenState();
}

class _WaterScheduleScreenState extends State<WaterScheduleScreen> {
  bool enableReminder = true;
  int selectedIndex = 0;
  TimeOfDay wakeUp = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay bedTime = const TimeOfDay(hour: 22, minute: 0);
  int dailyGoal = 2000;


  int frequencyMinutes = 60; // 30, 60, custom
  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final data = await FirebaseUserRepository().fetchUserData();
    setState(() {
      dailyGoal = data?['water']?['dailyGoal'] ?? 2000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF112117),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Đặt giờ uống nước',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _goalSection(),
            const SizedBox(height: 24),
            _enableReminder(),
            const SizedBox(height: 24),
            _activeHours(),
            const SizedBox(height: 24),
            _frequency(),
            const SizedBox(height: 24),
            _upcomingSchedule(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _saveButton(),
    );
  }

  Widget _enableReminder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable Reminders',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Get notified to stay hydrated',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          Switch(
            value: enableReminder,
            activeThumbColor: const Color(0xFF36E27B),
            activeTrackColor: const Color(0xFF36E27B),
            onChanged: (v) async {
              setState(() => enableReminder = v);
              if (v) {
                await NotificationService.repeatEveryMinutes(
                  id: 1,
                  minutes: 60,
                  title: "💧 Uống nước",
                  body: "Đến giờ uống nước rồi!",
                );
              } else {
                await NotificationService.cancelAll();
              }
            },
          )
        ],
      ),
    );
  }
  Widget _goalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF36E27B),
            child: Icon(Icons.water_drop, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hydration Goal",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 4),
              Text(
                "$dailyGoal ml",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeHours() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Hours',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _timeBox('Wake Up', wakeUp, () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: wakeUp,
                );
                if (t != null) setState(() => wakeUp = t);
              }),
              _timeBox('Bedtime', bedTime, () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: bedTime,
                );
                if (t != null) setState(() => bedTime = t);
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeBox(String label, TimeOfDay time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 4),
          Text(
            time.format(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _frequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _freqButton('30 Mins', 30),
            const SizedBox(width: 12),
            _freqButton('1 Hour', 60),
            const SizedBox(width: 12),
            _freqButton('Custom', -1),
          ],
        )
      ],
    );
  }

  Widget _freqButton(String label, int value) {
    final selected = frequencyMinutes == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => frequencyMinutes = value);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF36E27B) : const Color(0xFF1C2E24),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _upcomingSchedule() {
    final times = _generateTimesDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Schedule',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: times.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final t = times[i];
              final text =
                  '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

              return Container(
                width: 80,
                decoration: BoxDecoration(
                  color: i == 0
                      ? const Color(0xFF36E27B)
                      : const Color(0xFF1C2E24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: i == 0 ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }


  List<DateTime> _generateTimesDate() {
    if (frequencyMinutes <= 0) return [];

    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
      wakeUp.hour,
      wakeUp.minute,
    );

    var end = DateTime(
      now.year,
      now.month,
      now.day,
      bedTime.hour,
      bedTime.minute,
    );

    // ⏰ Nếu ngủ qua ngày mới (vd 22:00 → 06:00)
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    final result = <DateTime>[];
    var current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      result.add(current);
      current = current.add(Duration(minutes: frequencyMinutes));
    }

    return result;
  }


  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF36E27B),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: () async {
          try {
            // 1️⃣ Lưu config (local / firestore nếu có)
            await WaterReminderService.saveSettings(
              enabled: enableReminder,
              wakeUp: wakeUp,
              bedTime: bedTime,
              intervalMinutes: frequencyMinutes,
            );

            // 2️⃣ Huỷ toàn bộ notification cũ
            await WaterReminderService.cancelAll();

            // 3️⃣ Tạo notification mới nếu bật reminder
            if (enableReminder) {
              await WaterReminderService.scheduleDaily(
                wakeUp: wakeUp,
                bedTime: bedTime,
                intervalMinutes: frequencyMinutes,
              );
            }

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã lưu lịch uống nước 💧'),
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pop(context, true); // báo màn trước reload
          } catch (e) {
            debugPrint('SAVE SCHEDULE ERROR: $e');

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Có lỗi xảy ra khi lưu lịch ❌'),
              ),
            );
          }
        },
        child: const Text(
          'Save Schedule ✓',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
