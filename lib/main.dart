import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:kuvio/screens/start_screen.dart';
import 'package:kuvio/screens/admin_dashboard_screen.dart';
import 'package:kuvio/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const KuvioApp(),
    ),
  );
}

class KuvioApp extends StatelessWidget {
  const KuvioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Kuvio Kochapp',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode
          ? ThemeData(
              scaffoldBackgroundColor: const Color(0xFF1a1a1a),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
                bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
                titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
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
                primary: Color(0xFFFFFFFF),
                onPrimary: Color(0xFFFFFFFF),
              ),
              useMaterial3: true,
            )
          : ThemeData(
              scaffoldBackgroundColor: const Color(0xFF122620),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
                bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
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
