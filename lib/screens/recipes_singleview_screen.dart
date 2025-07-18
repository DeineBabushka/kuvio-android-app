import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../services/favorite_service.dart';
import '../services/shopping_list_service.dart';
import '../services/recipe_detail_service.dart';
import '../widgets/ingredient_list.dart';
import '../widgets/instruction_list.dart';
import '../widgets/nutrition_card.dart';
import '../widgets/comment_section.dart';
import '../widgets/portion_selector.dart';
import '../widgets/favorite_share_actions.dart';
import '../widgets/add_all_ingredients_button.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? recipeId;
  final String heroTag;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
    required this.heroTag,
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
    if (!mounted) return;
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final updated =
        await FavoriteService.toggleFavorite(user.uid, widget.recipeId!);
    if (!mounted) return;

    setState(() => isFavorite = updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated ? "Zu Favoriten hinzugefügt" : "Aus Favoriten entfernt",
        ),
      ),
    );
  }

  Future<void> _addAllToShoppingList(List<Ingredient> scaled) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    await ShoppingListService.addIngredients(
        user.uid, scaled, widget.recipeId!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Zutaten zur Einkaufsliste hinzugefügt")),
    );
  }

  Future<void> _addSingleToShoppingList(Ingredient ingredient) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    await ShoppingListService.addSingleIngredient(
        user.uid, ingredient, widget.recipeId!);

    if (!mounted) return;
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
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    final scaledIngredients = RecipeDetailService.getScaledIngredients(
      widget.recipe.ingredients,
      widget.recipe.portions,
      portionCount,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(backgroundColor, isLoggedIn),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildRecipeContent(
                context,
                textColor,
                cardColor,
                isLoggedIn,
                scaledIngredients,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Color backgroundColor, bool isLoggedIn) {
    final shareText = "🥗 ${widget.recipe.title}\n"
        "📋 Zutaten: ${widget.recipe.ingredients.map((e) => "${e.quantity} ${e.unit} ${e.name}").join(', ')}\n"
        "📖 Zubereitung: ${widget.recipe.instructions.take(3).join(' ')}...\n"
        "✨ Gekocht mit der Kuvio App!";

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isCollapsed = constraints.maxHeight < 140;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                key: ValueKey(isCollapsed ? 'collapsed' : 'expanded'),
                constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth - (isCollapsed ? 140 : 12)),
                child: Text(
                  widget.recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCollapsed ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              ),
            );
          },
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: widget.heroTag,
              child: Image.asset('assets/${widget.recipe.image}',
                  fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(153),
                    Colors.transparent,
                    Colors.black.withAlpha(153),
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
        FavoriteShareActions(
          title: widget.recipe.title,
          shareText: shareText,
          isFavorite: isFavorite,
          isLoggedIn: isLoggedIn,
          onToggleFavorite: _toggleFavorite,
        ),
      ],
    );
  }

  Widget _buildRecipeContent(
    BuildContext context,
    Color textColor,
    Color cardColor,
    bool isLoggedIn,
    List<Ingredient> scaledIngredients,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PortionSelector(
              portionCount: portionCount,
              onDecrement: () => setState(() =>
                  portionCount = (portionCount > 1) ? portionCount - 1 : 1),
              onIncrement: () => setState(() => portionCount++),
              textColor: textColor,
            ),
            Text('Dauer: ${widget.recipe.preparationTime}',
                style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Zutaten',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        IngredientList(
          ingredients: scaledIngredients,
          textColor: textColor,
          cardColor: cardColor,
          isLoggedIn: isLoggedIn,
          onAddToShoppingList: _addSingleToShoppingList,
        ),
        const SizedBox(height: 10),
        if (isLoggedIn)
          AddAllIngredientsButton(
            onPressed: () => _addAllToShoppingList(scaledIngredients),
          ),
        const SizedBox(height: 20),
        Text('Zubereitung',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        InstructionList(
          instructions: widget.recipe.instructions,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),
        Text('Nährwerte (pro Portion)',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
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
        if (isLoggedIn) CommentSection(recipeId: widget.recipeId!),
      ],
    );
  }
}
