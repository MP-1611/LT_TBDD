import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'features/auth/presentation/login_screen.dart';
import 'services/local_storage_service.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'services/app_startup_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  await LocalStorageService.init();
  initialRoute: AppStartupService.getInitialRoute();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generate,
    );
  }
}

