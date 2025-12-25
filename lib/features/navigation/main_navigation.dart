import 'package:flutter/material.dart';
import '../water/presentation/home_screen.dart';
import '../mission/presentation/weekly_mission_screen.dart';
import '../shop/presentation/shop_screen.dart';
import '../profile/presentation/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final screens = const [
    HomeScreen(),
    WeeklyMissionScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: const Color(0xFF36E27B),
        unselectedItemColor: Colors.white54,
        backgroundColor: const Color(0xFF0D1612),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Missions"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Shop"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
