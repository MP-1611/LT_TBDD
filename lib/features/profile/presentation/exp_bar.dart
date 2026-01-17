import 'package:flutter/material.dart';

class ExpBar extends StatelessWidget {
  final int level;
  final int currentXp;
  final int xpToNext;

  const ExpBar({
    super.key,
    required this.level,
    required this.currentXp,
    required this.xpToNext,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / xpToNext;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2620),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Level $level",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: Colors.black26,
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF36E27B),
                ),
                borderRadius: BorderRadius.circular(10),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            "$currentXp / $xpToNext XP",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
