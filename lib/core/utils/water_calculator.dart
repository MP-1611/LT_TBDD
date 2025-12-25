double calculateDailyWater({
  required double weightKg,
  required List<double> multipliers,
}) {
  final baseWater = weightKg * 35;

  double totalMultiplier = 1.0;
  for (final m in multipliers) {
    totalMultiplier += (m - 1);
  }

  return baseWater * totalMultiplier;
}
