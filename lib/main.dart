import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:kuvio/models/recipe.dart';

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

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            SizedBox(
              child: Image.asset('assets/logo.png', height: 350, width: 350),
            ),
            const SizedBox(height: 8),
            const Text(
              'Willkommen bei Kuvio!',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.7),
              child: Text(
                'Entdecke leckere Rezepte zum Nachkochen. Egal ob Anfänger oder Küchenprofi – mit Kuvio wird Kochen einfach, kreativ und lecker!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 150),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF122620),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Los geht’s',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String? selectedDiet;
  String? selectedCategory;
  List<Recipe> allRecipesList = []; // <-- Rezepteliste
  bool isLoading = true; // <-- Ladeanzeige

  @override
  void initState() {
    super.initState();
    loadRecipes(); // <-- Lade Rezepte beim Start
  }

  Future<void> loadRecipes() async {
    final String jsonString = await rootBundle.loadString('assets/recipe.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      allRecipesList =
          jsonData.map<Recipe>((item) => Recipe.fromJson(item)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF122620),
        body: Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF122620),
      appBar: AppBar(
        title: const Text("Rezeptauswahl"),
        backgroundColor: const Color(0xFF122620),
        actions: const [
          HamburgerMenu(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Was möchtest du heute kochen?",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterCircle('assets/rohkost_icon.png', 'Rohkost'),
                  _buildFilterCircle(
                      'assets/gluten_free_icon.png', 'Glutenfrei'),
                  _buildFilterCircle('assets/fish_icon.png', 'Fisch'),
                  _buildFilterCircle('assets/keto_icon.png', 'Keto'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterCircle('assets/proteins_icon.png', 'Fleisch'),
                  _buildFilterCircle(
                      'assets/vegetarian_icon.png', 'Vegetarisch'),
                  _buildFilterCircle('assets/alles_icon.png', 'Omnivor'),
                  _buildFilterCircle('assets/vegan_icon.png', 'Vegan'),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Wähle die Gerichtskategorie:",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildCategoryFilter("Vorspeise"),
                  _buildCategoryFilter("Hauptgericht"),
                  _buildCategoryFilter("Dessert"),
                  _buildCategoryFilter("Beilage"),
                  _buildCategoryFilter("Snack"),
                  _buildCategoryFilter("Frühstück"),
                  _buildCategoryFilter("Kalorienarm"),
                ],
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const RecipesListScreen(), // Navigiere zu RecipesListScreen
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF122620),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Zeige mir Rezepte',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterCircle(String assetPath, String label) {
    final isSelected = selectedDiet == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDiet = label;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(assetPath),
            backgroundColor:
                isSelected ? Colors.greenAccent : Colors.transparent,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.greenAccent : Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Color(0xFF122620),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RecipesListScreen extends StatelessWidget {
  const RecipesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezepte für dich"),
        backgroundColor: const Color(0xFF122620),
        actions: const [
          HamburgerMenu(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Obere Zeile mit der Farbe Color(0xFF122620)
            Container(
              color: const Color(0xFF122620),
              height: 10, // Höhe der oberen Zeile
            ),
            Expanded(
              child: Container(
                color: Colors.white, // Weißer Hintergrund für den Inhalt
                child: ListView.builder(
                  itemCount: 10, // Beispiel, hier werden 10 Rezepte angezeigt
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _buildRecipeRow(
                          "Rezept $index", // Beispiel-Titel
                          "assets/sample_image.png", // Beispiel-Bild
                          "assets/sample_icon.png", // Beispiel-Icon
                          "Vegetarisch", // Beispiel-Kategorie
                        ),
                        const Divider(
                          color:
                              Colors.grey, // Graue Linie zwischen den Rezepten
                          thickness: 1, // Dicke der Linie
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Untere Zeile mit der Farbe Color(0xFF122620)
            Container(
              color: const Color(0xFF122620),
              height: 10, // Höhe der unteren Zeile
            ),
          ],
        ),
      ),
    );
  }

  // Funktion, um eine Zeile mit einem Rezept zu erstellen
  Widget _buildRecipeRow(
    String title,
    String imageUrl,
    String iconUrl,
    String category,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.asset(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Image.asset(iconUrl, width: 20, height: 20, fit: BoxFit.cover),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
