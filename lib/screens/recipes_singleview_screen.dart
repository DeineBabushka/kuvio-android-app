import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../services/favorite_service.dart';
import '../services/shopping_list_service.dart';
import '../widgets/ingredient_list.dart';
import '../widgets/instruction_list.dart';
import '../widgets/nutrition_card.dart';
import '../comment_section.dart';

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
  bool isFavorite = false;
  int portionCount = 2;

  @override
  void initState() {
    super.initState();
    portionCount = widget.recipe.portions;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFavoriteStatus());
  }

  Future<void> _loadFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;
    final fav = await FavoriteService.isFavorite(user.uid, widget.recipeId!);
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final updated =
        await FavoriteService.toggleFavorite(user.uid, widget.recipeId!);
    setState(() => isFavorite = updated);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            updated ? "Zu Favoriten hinzugefügt" : "Aus Favoriten entfernt"),
      ),
    );
  }

  List<Ingredient> _getScaledIngredients() {
    final original = widget.recipe.portions;
    final factor = portionCount / original;

    return widget.recipe.ingredients
        .map((e) => Ingredient(
              quantity: e.quantity != null ? e.quantity! * factor : null,
              unit: e.unit,
              name: e.name,
            ))
        .toList();
  }

  Future<void> _addAllToShoppingList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final scaledIngredients = _getScaledIngredients();
    await ShoppingListService.addIngredients(
        user.uid, scaledIngredients, widget.recipeId!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zutaten zur Einkaufsliste hinzugefügt")),
    );
  }

  Future<void> _addSingleToShoppingList(Ingredient ingredient) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await ShoppingListService.addIngredients(
        user.uid, [ingredient], widget.recipeId!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${ingredient.name} hinzugefügt")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = const Color(0xFF2C2C2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              titlePadding:
                  const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              centerTitle: true,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.maxHeight < 140;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: ConstrainedBox(
                      key: ValueKey(isCollapsed ? 'collapsed' : 'expanded'),
                      constraints: BoxConstraints(
                          maxWidth:
                              constraints.maxWidth - (isCollapsed ? 140 : 32)),
                      child: Text(
                        widget.recipe.title,
                        maxLines: isCollapsed ? 1 : null,
                        overflow: TextOverflow.ellipsis,
                        softWrap: !isCollapsed,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isCollapsed ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(blurRadius: 4, color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/${widget.recipe.image}',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  final shareText = "🥗 ${widget.recipe.title}\n"
                      "📋 Zutaten: ${widget.recipe.ingredients.map((e) => "${e.quantity} ${e.unit} ${e.name}").join(', ')}\n"
                      "📖 Zubereitung: ${widget.recipe.instructions.take(3).join(' ')}...\n"
                      "✨ Gekocht mit der Kuvio App!";
                  Share.share(shareText);
                },
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildRecipeContent(context, textColor, cardColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeContent(
      BuildContext context, Color textColor, Color cardColor) {
    final scaledIngredients = _getScaledIngredients();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Portionen: ',
                    style: TextStyle(color: textColor, fontSize: 16)),
                IconButton(
                  onPressed: () => setState(() {
                    if (portionCount > 1) portionCount--;
                  }),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: textColor,
                ),
                Text('$portionCount',
                    style: TextStyle(color: textColor, fontSize: 16)),
                IconButton(
                  onPressed: () => setState(() => portionCount++),
                  icon: const Icon(Icons.add_circle_outline),
                  color: textColor,
                ),
              ],
            ),
            Text('Dauer: ${widget.recipe.preparationTime}',
                style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Zutaten',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        IngredientList(
          ingredients: scaledIngredients,
          textColor: textColor,
          cardColor: cardColor,
          onAddToShoppingList: _addSingleToShoppingList,
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton.icon(
            onPressed: _addAllToShoppingList,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Alle Zutaten hinzufügen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Zubereitung',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InstructionList(
          instructions: widget.recipe.instructions,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),
        Text('Nährwerte (pro Portion)',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        NutritionCard(
          calories: widget.recipe.calories,
          protein: widget.recipe.proteinG,
          carbs: widget.recipe.carbohydratesG,
          fat: widget.recipe.fatG,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),
        CommentSection(recipeId: widget.recipeId!),
      ],
    );
  }
}
