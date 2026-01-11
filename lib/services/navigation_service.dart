import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<void> pushNamed(String route, {Object? arguments}) async {
    navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  static Future<void> pushReplacementNamed(String route) async {
    navigatorKey.currentState?.pushReplacementNamed(route);
  }
}