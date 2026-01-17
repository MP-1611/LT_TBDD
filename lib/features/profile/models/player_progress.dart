class PlayerProgress {
  final int level;
  final int currentXp;
  final int xpToNextLevel;

  PlayerProgress({
    required this.level,
    required this.currentXp,
    required this.xpToNextLevel,
  });

  double get progress => currentXp / xpToNextLevel;
}
