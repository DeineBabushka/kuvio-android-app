import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:kuvio/screens/start_screen.dart';
import 'package:kuvio/screens/admin_dashboard_screen.dart';
import 'package:kuvio/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await uploadRecipesToFirestore();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const KuvioApp(),
    ),
  );
}

Future<void> uploadRecipesToFirestore() async {
  try {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final recipesCollection = FirebaseFirestore.instance.collection('recipes');

    for (final recipe in jsonData) {
      await recipesCollection.add({
        'title': recipe['title'],
        'image': recipe['image'],
        'portions': recipe['portions'],
        'ingredients': recipe['ingredients'],
        'instructions': recipe['instructions'],
        'diet_types': recipe['diet_types'],
        'categories': recipe['categories'],
        'preparation_time': recipe['preparation_time'],
        'nutrition': {
          'calories': recipe['nutrition']['calories'],
          'protein_g': recipe['nutrition']['protein_g'],
          'carbohydrates_g': recipe['nutrition']['carbohydrates_g'],
          'fat_g': recipe['nutrition']['fat_g'],
        },
      });
    }

    print('✅ Rezepte erfolgreich hochgeladen!');
  } catch (e) {
    print('❌ Fehler beim Hochladen der Rezepte: $e');
  }
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
