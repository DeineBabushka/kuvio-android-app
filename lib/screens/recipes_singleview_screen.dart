import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadRecipeComments();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkIfFavorite());
  }

  Future<void> checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];

    setState(() {
      isFavorite = favorites.contains(widget.recipeId);
    });
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');

    final userDoc = await userDocRef.get();
    final List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];

    final isCurrentlyFavorite = favorites.contains(widget.recipeId);

    if (isCurrentlyFavorite) {
      await userDocRef.update({
        'favorites': FieldValue.arrayRemove([widget.recipeId]),
      });

      final favSnapshot = await favoritesCollection
          .where('userId', isEqualTo: user.uid)
          .where('recipeId', isEqualTo: widget.recipeId)
          .get();

      for (var doc in favSnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() => isFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aus Favoriten entfernt")),
      );
    } else {
      await userDocRef.update({
        'favorites': FieldValue.arrayUnion([widget.recipeId]),
      });

      await favoritesCollection.add({
        'userId': user.uid,
        'recipeId': widget.recipeId,
        'addedAt': FieldValue.serverTimestamp(),
      });

      setState(() => isFavorite = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Zu Favoriten hinzugefügt")),
      );
    }
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(widget.recipe.title, style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final shareText = '''
🥗 ${widget.recipe.title}

📋 Zutaten:
${widget.recipe.ingredients.join(', ')}

📖 Zubereitung:
${widget.recipe.instructions.take(3).join('\n')}...

✨ Gekocht mit der Kuvio App!
''';
                  Share.share(shareText);
                },
                icon: const Icon(Icons.share),
                label: const Text("Teilen"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF417B5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Portionen: ${widget.recipe.portions}',
                    style: TextStyle(color: textColor, fontSize: 16)),
                Text('Dauer: ${widget.recipe.preparationTime}',
                    style: TextStyle(color: textColor, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Zutaten',
                style: TextStyle(
                    color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('• $ingredient',
                      style: TextStyle(color: textColor, fontSize: 16)),
                )),
            const SizedBox(height: 20),
            Text('Zubereitung',
                style: TextStyle(
                    color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.recipe.instructions.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(step,
                      style: TextStyle(color: textColor, fontSize: 16)),
                )),
            const SizedBox(height: 20),
            Text('Nährwerte (pro Portion)',
                style: TextStyle(
                    color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Kalorien: ${widget.recipe.calories} kcal',
                style: TextStyle(color: textColor, fontSize: 16)),
            Text('Protein: ${widget.recipe.proteinG} g',
                style: TextStyle(color: textColor, fontSize: 16)),
            Text('Kohlenhydrate: ${widget.recipe.carbohydratesG} g',
                style: TextStyle(color: textColor, fontSize: 16)),
            Text('Fett: ${widget.recipe.fatG} g',
                style: TextStyle(color: textColor, fontSize: 16)),
            const SizedBox(height: 30),
            Divider(color: textColor.withOpacity(0.5)),
            Text('Kommentare',
                style: TextStyle(
                    color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (isLoading)
              const CircularProgressIndicator()
            else if (comments.isEmpty)
              Text("Keine Kommentare vorhanden.",
                  style: TextStyle(color: textColor))
            else
              ...comments.map((comment) => ListTile(
                    tileColor: cardColor,
                    title: Text(comment.username,
                        style: TextStyle(color: textColor)),
                    subtitle: Text(comment.text,
                        style: TextStyle(color: textColor.withOpacity(0.7))),
                    trailing: Text(
                      '${comment.timestamp.day.toString().padLeft(2, '0')}.${comment.timestamp.month.toString().padLeft(2, '0')}.${comment.timestamp.year} – '
                      '${comment.timestamp.hour.toString().padLeft(2, '0')}:${comment.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                          color: textColor.withOpacity(0.5), fontSize: 12),
                    ),
                  )),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Kommentar schreiben...',
                      hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: textColor),
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
