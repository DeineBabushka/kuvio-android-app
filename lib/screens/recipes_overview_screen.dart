import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../models/comment.dart';
import '../services/comment_service.dart'; // enthält loadComments()

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? recipeId; // Firestore-Dokument-ID

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final TextEditingController commentController = TextEditingController();
  List<Comment> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecipeComments();
  }

  Future<void> loadRecipeComments() async {
    comments = await loadComments(widget.recipeId!);
    setState(() => isLoading = false);
  }

  Future<void> addComment(Comment comment) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .collection('comments')
        .add(comment.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF122620),
        title: Text(
          widget.recipe.title,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF122620),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/${widget.recipe.image}',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portionen: ${widget.recipe.portions}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Dauer: ${widget.recipe.preparationTime}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Zutaten',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.recipe.ingredients.map(
              (ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '• $ingredient',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Zubereitung',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.recipe.instructions.map(
              (step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  step,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nährwerte (pro Portion)',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Kalorien: ${widget.recipe.calories} kcal',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Protein: ${widget.recipe.proteinG} g',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Kohlenhydrate: ${widget.recipe.carbohydratesG} g',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Fett: ${widget.recipe.fatG} g',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white54),
            const Text(
              'Kommentare',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const CircularProgressIndicator()
            else if (comments.isEmpty)
              const Text("Keine Kommentare vorhanden.",
                  style: TextStyle(color: Colors.white))
            else
              ...comments.map((comment) => ListTile(
                    title: Text(comment.username,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(comment.text,
                        style: const TextStyle(color: Colors.white70)),
                    trailing: Text(
                      '${comment.timestamp.day}.${comment.timestamp.month}.${comment.timestamp.year}',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  )),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Kommentar schreiben...',
                      hintStyle: TextStyle(color: Colors.white54),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color.fromARGB(255, 255, 255, 255)),
                  onPressed: () async {
                    if (commentController.text.trim().isEmpty) return;

                    final newComment = Comment(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: 'user_1',
                      username: 'Max', // später dynamisch vom eingeloggten User
                      text: commentController.text.trim(),
                      timestamp: DateTime.now(),
                    );

                    await addComment(newComment);
                    commentController.clear();
                    await loadRecipeComments(); // neu laden
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
