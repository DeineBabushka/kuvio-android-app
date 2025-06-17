import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../models/comment.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? recipeId;

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
    if (widget.recipeId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('recipeId', isEqualTo: widget.recipeId!)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        comments =
            snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
        isLoading = false;
      });
    } catch (e) {
      print('❌ Fehler beim Laden der Kommentare: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> addComment(Comment comment) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('comments').doc();
      final commentWithId = comment.copyWith(id: docRef.id);
      await docRef.set(commentWithId.toMap());
    } catch (e) {
      print('❌ Fehler beim Hinzufügen des Kommentars: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF122620),
        title: Text(widget.recipe.title,
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF122620),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rezeptbild
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.asset(
                    'assets/${widget.recipe.image}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Portionen und Dauer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Portionen: ${widget.recipe.portions}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text('Dauer: ${widget.recipe.preparationTime}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),

            // Zutaten
            const Text('Zutaten',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('• $ingredient',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                )),
            const SizedBox(height: 20),

            // Zubereitung
            const Text('Zubereitung',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.recipe.instructions.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(step,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                )),
            const SizedBox(height: 20),

            // Nährwerte
            const Text('Nährwerte (pro Portion)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Kalorien: ${widget.recipe.calories} kcal',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text('Protein: ${widget.recipe.proteinG} g',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text('Kohlenhydrate: ${widget.recipe.carbohydratesG} g',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text('Fett: ${widget.recipe.fatG} g',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 30),

            const Divider(color: Colors.white54),

            // Kommentare
            const Text('Kommentare',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
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
                      '${comment.timestamp.day.toString().padLeft(2, '0')}.${comment.timestamp.month.toString().padLeft(2, '0')}.${comment.timestamp.year} – '
                      '${comment.timestamp.hour.toString().padLeft(2, '0')}:${comment.timestamp.minute.toString().padLeft(2, '0')}',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  )),
            const SizedBox(height: 10),

            // Kommentar schreiben
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
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    final text = commentController.text.trim();
                    if (text.isEmpty) return;

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('❌ Du musst eingeloggt sein.')),
                      );
                      return;
                    }

                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get();

                    final newComment = Comment(
                      id: '',
                      userId: user.uid,
                      username: userDoc.data()?['username'] ?? 'Unbekannt',
                      recipeId: widget.recipeId!,
                      text: text,
                      timestamp: DateTime.now(),
                    );

                    await addComment(newComment);
                    commentController.clear();
                    await loadRecipeComments();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
