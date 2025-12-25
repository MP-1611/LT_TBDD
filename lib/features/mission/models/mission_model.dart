import 'package:flutter/material.dart';

enum MissionStatus { locked, active, completed }

class Mission {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int reward;
  final String rewardType; // XP / Drops
  final double progress; // 0 → 1
  final MissionStatus status;
  final Color color;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.reward,
    required this.rewardType,
    required this.progress,
    required this.status,
    required this.color,
  });
}
