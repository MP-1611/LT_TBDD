import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------- USER ----------
  static Future setWeight(double value) async =>
      _prefs.setDouble("weight", value);

  static double getWeight() => _prefs.getDouble("weight") ?? 60;

  static Future setGender(String gender) async =>
      _prefs.setString("gender", gender);

  static String getGender() => _prefs.getString("gender") ?? "male";

  static Future setWakeUp(String time) async =>
      _prefs.setString("wake_up", time);

  static String getWakeUp() => _prefs.getString("wake_up") ?? "07:00";

  // ---------- WATER ----------
  static Future setDailyGoal(int ml) async =>
      _prefs.setInt("daily_goal", ml);

  static int getDailyGoal() => _prefs.getInt("daily_goal") ?? 2000;

  static Future setCurrentWater(int ml) async =>
      _prefs.setInt("current_water", ml);

  static int getCurrentWater() => _prefs.getInt("current_water") ?? 0;

  // ---------- INTEREST ----------
  static Future setInterests(List<String> list) async =>
      _prefs.setStringList("interests", list);

  static List<String> getInterests() =>
      _prefs.getStringList("interests") ?? [];

  // ---------- LEVEL ----------
  static Future setLevel(int level) async =>
      _prefs.setInt("level", level);

  static int getLevel() => _prefs.getInt("level") ?? 1;

  static Future setXP(int xp) async =>
      _prefs.setInt("xp", xp);

  static int getXP() => _prefs.getInt("xp") ?? 0;

  static Future setDrops(int drops) async =>
      _prefs.setInt("drops", drops);

  static int getDrops() => _prefs.getInt("drops") ?? 0;

  // ---------- Reset ----------
  static const _lastResetKey = 'last_reset_date';

  static Future<void> setLastResetDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastResetKey, date);
  }

  static Future<String?> getLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastResetKey);
  }

}

