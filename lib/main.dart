import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kuvio/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/shared/services/theme_provider.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';
import 'package:kuvio/shared/services/offline_cache_service.dart';
import 'package:kuvio/features/app/screens/start_screen.dart';
import 'package:kuvio/features/admin/screens/admin_dashboard_screen.dart';
import 'package:kuvio/features/auth/screens/login_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kuvio/l10n/app_localizations.dart';
import 'package:kuvio/l10n/l10n.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity != ConnectivityResult.none;

    if (isOnline) {
      try {
        await FirebaseFirestore.instance.disableNetwork();
        await FirebaseFirestore.instance.enableNetwork();
        await OfflineCacheService.preloadAll();
      } catch (e) {
        debugPrint("⚠️ Fehler beim Caching: $e");
      }
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ],
        child: const KuvioApp(),
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class KuvioApp extends StatefulWidget {
  const KuvioApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_KuvioAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<KuvioApp> createState() => _KuvioAppState();
}

class _KuvioAppState extends State<KuvioApp> {
  Locale _locale = const Locale('de');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: themeProvider.isDarkMode ? _darkTheme : _lightTheme,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
      home: const StartScreen(),
    );
  }
}

final _darkTheme = ThemeData(
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
  ).copyWith(primary: Colors.white),
  useMaterial3: true,
);

final _lightTheme = ThemeData(
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
  ).copyWith(primary: Color(0xFF2E6B4D)),
  useMaterial3: true,
);
