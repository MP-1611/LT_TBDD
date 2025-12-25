import 'package:flutter/material.dart';
import 'package:h20_reminder/services/local_storage_service.dart';
import 'package:h20_reminder/routes/app_routes.dart';

enum Gender { male, female, other }

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();

}

String _formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  Gender selectedGender = Gender.female;
  double weight = 52;
  TimeOfDay wakeUpTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _appBar(),
                _progress(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin cá nhân",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _helperCard(),
                        const SizedBox(height: 28),
                        _genderSection(),
                        const SizedBox(height: 32),
                        _weightSection(),
                        const SizedBox(height: 32),
                        _wakeUpSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _bottomButton(),
        ],
      ),
    );
  }

  // ---------- UI PARTS ----------

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: const [
          BackButton(color: Colors.white),
          Expanded(
            child: Center(
              child: Text(
                "AquaMate Setup",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dot(active: true, width: 32),
          _dot(),
          _dot(),
          _dot(),
        ],
      ),
    );
  }

  Widget _dot({bool active = false, double width = 8}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF36E27B) : Colors.white24,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _helperCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2E24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hello friend! 👋",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Giúp mình hiểu rõ hơn về cơ thể bạn để tính lượng nước cần thiết nhé!",
                  style: TextStyle(color: Color(0xFF9EB7A8)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFF36E27B),
            child: Image.asset("assets/images/mascot.png"),
          ),
        ],
      ),
    );
  }

  Widget _genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Giới tính",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _genderItem(Gender.male, Icons.male, "Nam"),
            const SizedBox(width: 12),
            _genderItem(Gender.female, Icons.female, "Nữ"),
            const SizedBox(width: 12),
            _genderItem(Gender.other, Icons.transgender, "Khác"),
          ],
        ),
      ],
    );
  }

  Widget _genderItem(Gender gender, IconData icon, String label) {
    final selected = selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2A4235) : const Color(0xFF1C2E24),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? const Color(0xFF36E27B)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              if (selected)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF36E27B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Selected",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 32,
                      color: selected
                          ? const Color(0xFF36E27B)
                          : Colors.white54,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                        color: selected ? Colors.white : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Cân nặng",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                text: weight.toInt().toString(),
                style: const TextStyle(
                  color: Color(0xFF36E27B),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                children: const [
                  TextSpan(
                    text: " kg",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          min: 30,
          max: 150,
          value: weight,
          activeColor: const Color(0xFF36E27B),
          inactiveColor: Colors.white12,
          onChanged: (v) => setState(() => weight = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("30kg", style: TextStyle(color: Colors.white38)),
            Text("150kg", style: TextStyle(color: Colors.white38)),
          ],
        ),
      ],
    );
  }

  Widget _wakeUpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thời gian thức dậy",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: wakeUpTime,
            );
            if (picked != null) {
              setState(() => wakeUpTime = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2E24),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.wb_sunny, color: Colors.orange),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giờ bắt đầu ngày mới",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Để nhắc uống nước buổi sáng",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  wakeUpTime.format(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomButton() {
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF36E27B),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            String genderString = selectedGender.name;
            // Lưu thông tin user
            await LocalStorageService.setWeight(weight);
            await LocalStorageService.setGender(selectedGender.name);
            await LocalStorageService.setWakeUp(_formatTime(wakeUpTime));

            if (!mounted) return;

            Navigator.pushNamed(
              context,
              AppRoutes.interests,
            );
          },
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
      ),
    );
  }
}
