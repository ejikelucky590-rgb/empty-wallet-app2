import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Fetch credentials securely from the compilation environment flags
  const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  const String supabaseKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    // DIAGNOSTICS UPDATE: Show exactly which variable is failing to load
    bootstrapError = "Configuration Error: Missing Supabase environment compilation flags.\n\n"
                     "🔍 DIAGNOSTICS:\n"
                     "-> SUPABASE_URL detected: ${supabaseUrl.isNotEmpty ? 'YES (Length: ${supabaseUrl.length})' : 'NO (EMPTY)'}\n"
                     "-> SUPABASE_ANON_KEY detected: ${supabaseKey.isNotEmpty ? 'YES (Length: ${supabaseKey.length})' : 'NO (EMPTY)'}\n\n"
                     "Please check your GitHub Repository Secrets spelling and deployment environment configuration.";
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    ).timeout(const Duration(seconds: 4));
  } catch (e, stack) {
    bootstrapError = "Database Engine Error: $e\n\nStacktrace: $stack";
  }
}

Future<void> main() async {
  await bootstrap();

  if (bootstrapError != null) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Text(
                bootstrapError!,
                style: const TextStyle(
                  color: Colors.redAccent, 
                  fontFamily: 'monospace', 
                  fontSize: 14,
                  height: 1.5,
                ),
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
