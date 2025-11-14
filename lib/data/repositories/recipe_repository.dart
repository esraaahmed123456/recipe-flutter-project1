import '../../core/dio_client.dart';
import '../../core/constants.dart';
import '../models/recipe_model.dart';
import '../local/database_provider.dart';

class RecipeRepository {
  final DioClient dioClient;
  final DatabaseProvider db;

  RecipeRepository({DioClient? client, DatabaseProvider? databaseProvider})
      : dioClient = client ?? DioClient(),
        db = databaseProvider ?? DatabaseProvider();

  Future<List<Recipe>> fetchRecipes({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      try {
        final cached = await db.getRecipes();
        if (cached.isNotEmpty) return cached;
      } catch (_) {}
    }

    final response = await dioClient.get(Constants.recipesEndpoint);
    if (response.statusCode == 200) {
      final map = response.data as Map<String, dynamic>;
      final list = map['recipes'] as List<dynamic>;
      final recipes = list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
      try {
        await db.clearRecipes();
        await db.insertRecipes(recipes);
      } catch (_) {}
      return recipes;
    } else {
      throw Exception('Failed to load recipes ${response.statusCode}');
    }
  }
}
