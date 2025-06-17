import 'package:flutter/material.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';

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
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _buildRecipeRow(
                          "Rezept $index",
                          "assets/sample_image.png",
                          "assets/sample_icon.png",
                          "Vegetarisch",
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
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
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

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
