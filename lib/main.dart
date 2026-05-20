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

  // Load configuration with safe silent try-catch block
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Notice: Local .env file not found. Reading system variables.");
  }

  // Pure bulletproof fallback strategy using standard .getOrElse()
  final String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: 'https://bpxqlhfntpdqnlddrlpc.supabase.co');
  final String supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: 'sb_publishable_MMsTIt81-QakeUPVxj-hlQ_kLOghDu5');

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  try {
    // Rigid 4-second initialization timeout container safeguard
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    ).timeout(const Duration(seconds: 4), onTimeout: () {
      debugPrint("Supabase engine timed out. Continuing launch flow.");
      return Supabase.instance;
    });
  } catch (e) {
    debugPrint("Supabase initialization bypassed safely: $e");
  }
}

Future<void> main() async {
  await bootstrap();

  runZonedGuarded(() {
    runApp(const DoveApp());
  }, (error, stack) {
    debugPrint("Zoned boundary caught error: $error");
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
