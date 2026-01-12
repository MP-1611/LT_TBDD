import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:h20_reminder/services/app_startup_service.dart';
import 'package:h20_reminder/services/navigation_service.dart';
import 'package:h20_reminder/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';
import 'services/local_storage_service.dart';
import 'routes/route_generator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorageService.init();
  await NotificationService.init();
  await initializeDateFormatting('vi_VN', null);
  Intl.defaultLocale = 'vi_VN';
  final initialRoute = await AppStartupService.getInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generate,
    );
  }
}


