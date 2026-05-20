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

  // Load configuration with silent fallback
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Notice: Standard local .env container not found. Checking runtime bindings.");
  }

  // Ensure variables never evaluate to a critical null point on the web layer
  final String supabaseUrl = dotenv.maybeEnv['SUPABASE_URL'] ?? 'https://bpxqlhfntpdqnlddrlpc.supabase.co';
  final String supabaseKey = dotenv.maybeEnv['SUPABASE_ANON_KEY'] ?? 'sb_publishable_MMsTIt81-QakeUPVxj-hlQ_kLOghDu5';

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };

  try {
    // 4-second maximum safety barrier to completely guarantee the UI mounts
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    ).timeout(const Duration(seconds: 4), onTimeout: () {
      debugPrint("Supabase initialization exceeded timeout limit. Launching UI core standalone.");
      return Supabase.instance;
    });
    debugPrint("Supabase engine status linked cleanly.");
  } catch (e) {
    debugPrint("Supabase bypass active: $e");
  }
}

Future<void> main() async {
  await bootstrap();

  runZonedGuarded(() {
    runApp(const DoveApp());
  }, (error, stack) {
    debugPrint("Safely caught boundary state change: $error");
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
