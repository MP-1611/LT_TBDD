import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:h20_reminder/services/app_startup_service.dart';
import 'firebase_options.dart';
import 'services/local_storage_service.dart';
import 'routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorageService.init();

  final initialRoute = await AppStartupService.getInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute, // ✅ DÙNG ROUTE TÍNH ĐƯỢC
      onGenerateRoute: RouteGenerator.generate,
    );
  }
}


