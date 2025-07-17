import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/theme_provider.dart';
import 'package:kuvio/screens/start_screen.dart';
import 'package:kuvio/screens/admin_dashboard_screen.dart';
import 'package:kuvio/screens/login_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fehler aus dem Flutter-Framework an Crashlytics senden
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Fehler außerhalb des Flutter-Kontexts (z. B. async) an Crashlytics senden
  runZonedGuarded(
    () {
      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const KuvioApp(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

class KuvioApp extends StatelessWidget {
  const KuvioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final analytics = FirebaseAnalytics.instance;

    return MaterialApp(
      title: 'Kuvio Kochapp',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: themeProvider.isDarkMode
          ? ThemeData(
              scaffoldBackgroundColor: const Color(0xFF1a1a1a),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1a1a1a),
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0E1415),
                  foregroundColor: Color(0xFF2E6B4D),
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF959595),
                brightness: Brightness.dark,
              ).copyWith(
                primary: Colors.white,
              ),
              useMaterial3: true,
            )
          : ThemeData(
              scaffoldBackgroundColor: const Color(0xFF122620),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Color(0xFF122620)),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF122620),
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF2E6B4D),
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF122620),
                brightness: Brightness.light,
              ).copyWith(
                primary: Color(0xFF2E6B4D),
              ),
              useMaterial3: true,
            ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
      home: const StartScreen(),
    );
  }
}
