import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/dove_theme.dart';
import 'core/router.dart';

String? bootstrapError;

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  String supabaseUrl = 'https://bpxqlhfntpdqnlddrlpc.supabase.co';
  String supabaseKey = 'sb_publishable_MMsTIt81-QakeUPVxj-hlQ_kLOghDu5';

  // Safe isolated try-catch specifically for the dotenv parsing layer
  try {
    await dotenv.load(fileName: ".env");
    supabaseUrl = dotenv.get('SUPABASE_URL', fallback: supabaseUrl);
    supabaseKey = dotenv.get('SUPABASE_ANON_KEY', fallback: supabaseKey);
  } catch (e) {
    debugPrint("Bypassing missing asset file bundle: $e");
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    ).timeout(const Duration(seconds: 4));
  } catch (e, stack) {
    // Only flag critical infrastructure connection failures
    bootstrapError = "Database Engine Error: $e\n\nStacktrace: $stack";
  }
}

Future<void> main() async {
  await bootstrap();

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
    debugPrint("Zoned caught exception: $error");
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
