import 'package:flutter/material.dart';

void main() {
  runApp(const KuvioApp());
}

// Root-Widget deiner App
class KuvioApp extends StatelessWidget {
  const KuvioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuvio Kochapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Der Startscreen der App
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuvio Kochapp')),
      body: const Center(
        child: Text(
          'Willkommen zur Kuvio Kochapp Gloger!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
