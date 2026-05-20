import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/dove_theme.dart';
import 'core/router.dart';

// Global string to catch initialization crashes
String? bootstrapError;

Future<void> bootstrap() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    if (!kIsWeb) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("Notice: Local .env file missing.");
    }

    final String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: 'https://bpxqlhfntpdqnlddrlpc.supabase.co');
    final String supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: 'sb_publishable_MMsTIt81-QakeUPVxj-hlQ_kLOghDu5');

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    ).timeout(const Duration(seconds: 4));
    
  } catch (e, stack) {
    // Capture the exact crash reason to display on the screen
    bootstrapError = "Bootstrap Crash: $e\n\nStacktrace: $stack";
  }
}

Future<void> main() async {
  await bootstrap();

  // If a bootstrap error happened, we completely bypass the router and show the error text
  if (bootstrapError != null) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                bootstrapError!,
                style: const TextStyle(color: Colors.red, fontFamily: 'monospace', fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    ));
    return;
  }

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
