import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/favorites_cubit.dart';
import '../../logic/cubit/recipe_cubit.dart';
import '../widgets/recipe_card.dart';
import '../../data/models/recipe_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final favIds = context.watch<FavoritesCubit>().state;
    final recipesState = context.watch<RecipeCubit>().state;
    List<Recipe> favorites = [];
    if (recipesState is RecipeLoaded) {
      favorites = recipesState.recipes.where((r) => favIds.contains(r.id.toString())).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite recipes yet 🍽️"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];
                return RecipeCard(recipe: recipe, onTap: () => Navigator.pushNamed(context, '/details', arguments: recipe));
              },
            ),
    );
  }
}
