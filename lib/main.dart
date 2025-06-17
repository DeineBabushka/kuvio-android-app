import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:kuvio/screens/start_screen.dart';

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
              scaffoldBackgroundColor: const Color(0xFF122620),
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            )
          : ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFF122620)),
                bodyLarge: TextStyle(color: Color(0xFF122620)),
                titleLarge: TextStyle(color: Color(0xFF122620)),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF122620),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
      home: const StartScreen(),
    );
  }
}
