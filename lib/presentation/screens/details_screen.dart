import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/recipe_model.dart';
import '../../logic/cubit/favorites_cubit.dart';

class DetailsScreen extends StatelessWidget {
  final Recipe recipe;
  const DetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final favors = context.watch<FavoritesCubit>();
    final isFav = favors.isFavorite(recipe.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              if (isFav) {
                context.read<FavoritesCubit>().removeFavorite(recipe.id.toString());
              } else {
                context.read<FavoritesCubit>().addFavorite(recipe.id.toString());
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: recipe.image.isNotEmpty
                ? Image.network(recipe.image, height: 220, width: double.infinity, fit: BoxFit.cover)
                : Container(height:220,color:Colors.grey[300],child: Icon(Icons.restaurant,size:64)),
          ),
          const SizedBox(height:12),
          Text(recipe.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height:8),
          Text('${recipe.cuisine} • ${recipe.difficulty} • ${recipe.rating} ⭐'),
          const SizedBox(height:12),
          Text('Ingredients:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height:6),
          ...recipe.ingredients.map((i) => Text('• ' + i)),
          const SizedBox(height:12),
          Text('Instructions:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height:6),
          ...recipe.instructions.map((s) => Text('• ' + s)),
        ],
      ),
    );
  }
}
