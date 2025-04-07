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
<<<<<<< HEAD
=======
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //Änderung
>>>>>>> 9a1712a458989091589c3dde5ec7e1e6625d2fdc
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
