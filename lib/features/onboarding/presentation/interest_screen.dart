import 'package:flutter/material.dart';
import '../models/interest_model.dart';
import 'package:h20_reminder/features/onboarding/presentation/water_result_screen.dart';
import 'package:h20_reminder/services/local_storage_service.dart';
import 'package:h20_reminder/routes/app_routes.dart';


class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  final List<Interest> interests = [
    Interest(
      id: "exercise",
      title: "Tập thể dục",
      icon: Icons.directions_run,
      waterMultiplier: 1.3,
    ),
    Interest(
      id: "study",
      title: "Học tập",
      icon: Icons.school,
      waterMultiplier: 1.1,
    ),
    Interest(
      id: "gaming",
      title: "Chơi game",
      icon: Icons.sports_esports,
      waterMultiplier: 1.15,
    ),
    Interest(
      id: "work",
      title: "Làm việc",
      icon: Icons.work,
      waterMultiplier: 1.1,
    ),
    Interest(
      id: "outdoor",
      title: "Ngoài trời",
      icon: Icons.wb_sunny,
      waterMultiplier: 1.25,
    ),
  ];

  final Set<String> selectedIds = {"exercise", "gaming"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(),
                _progress(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sở thích &\nhoạt động",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Chọn các hoạt động thường ngày để AquaMate tính toán lượng nước phù hợp cho bạn.",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 28),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemCount: interests.length + 1,
                          itemBuilder: (context, index) {
                            if (index == interests.length) {
                              return _addMoreCard();
                            }
                            final item = interests[index];
                            final selected =
                            selectedIds.contains(item.id);
                            return _interestCard(item, selected);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _bottomAction(),
        ],
      ),
    );
  }

  // ---------- UI PARTS ----------

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: const [
          BackButton(color: Colors.white),
          Spacer(),
          Text(
            "Bước 2 / 4",
            style: TextStyle(color: Colors.white54),
          ),
          Spacer(),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _bar(true),
          _bar(true),
          _bar(false),
          _bar(false),
        ],
      ),
    );
  }

  Widget _bar(bool active) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 6,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF36E27B) : Colors.white24,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _interestCard(Interest interest, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected
              ? selectedIds.remove(interest.id)
              : selectedIds.add(interest.id);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF36E27B).withOpacity(0.12)
              : const Color(0xFF1A2C22),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: selected
                ? const Color(0xFF36E27B)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF36E27B).withOpacity(0.2),
              blurRadius: 20,
            )
          ]
              : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: selected
                      ? const Color(0xFF36E27B)
                      : Colors.white12,
                  child: Icon(
                    interest.icon,
                    color: selected ? Colors.black : Colors.white54,
                  ),
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: selected
                      ? const Color(0xFF36E27B)
                      : Colors.transparent,
                  child: selected
                      ? const Icon(Icons.check,
                      size: 16, color: Colors.black)
                      : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                      Border.all(color: Colors.white24),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              interest.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMoreCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white24,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.white38, size: 28),
            SizedBox(height: 8),
            Text(
              "Thêm khác",
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomAction() {
    final canContinue = selectedIds.isNotEmpty;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Color(0xFF112117),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!canContinue)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2C22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Tuyệt vời! Chọn ít nhất 1 cái nhé!",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canContinue
                    ? const Color(0xFF36E27B)
                    : Colors.white24,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: canContinue
                  ? () async  {
                await LocalStorageService.setInterests(
                  selectedIds.toList(),
                );
                final multipliers = interests
                    .where((i) => selectedIds.contains(i.id))
                    .map((i) => i.waterMultiplier)
                    .toList();
                final weight = LocalStorageService.getWeight();
                final dailyGoal = (weight * 35 *
                    multipliers.fold(1.0, (a, b) => a * b))
                    .round();
                if (!mounted) return;
                Navigator.pushNamed(
                  context,
                  AppRoutes.waterResult,
                  arguments: {
                    "weight": weight,
                    "multipliers": multipliers,
                    "dailyGoal": dailyGoal,
                  },
                );
              }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Tiếp tục",
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
    );
  }
}
