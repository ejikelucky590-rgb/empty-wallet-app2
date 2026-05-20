import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/dove_theme.dart';
import 'core/router.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: No .env configuration runtime file discovered.");
  }

  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final String supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    // Timeout safeguard protects the web canvas if the backend is sleeping or paused
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      ).timeout(const Duration(seconds: 4), onTimeout: () {
        throw TimeoutException("Supabase initialization timed out. Server might be paused.");
      });
      debugPrint("Supabase initialized successfully.");
    } catch (e) {
      debugPrint("Supabase Boot Error: $e. Proceeding to render UI container safely.");
    }
  } else {
    debugPrint("Critical Error: Missing environmental keys configuration.");
  }
}

Future<void> main() async {
  await bootstrap();

  runZonedGuarded(() {
    runApp(const DoveApp());
  }, (error, stack) {
    debugPrint("Zoned boundary caught error safely: $error");
  });
}

class DoveApp extends StatelessWidget {
  const DoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dove Music',
      theme: DoveTheme.darkTheme,
      routerConfig: router,
    );
  }
}
