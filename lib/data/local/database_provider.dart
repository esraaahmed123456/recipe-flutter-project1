import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants.dart';
import '../models/recipe_model.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'recipes_app.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Constants.recipesTable} (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        image TEXT,
        cuisine TEXT,
        difficulty TEXT,
        rating REAL,
        caloriesPerServing INTEGER,
        cookTimeMinutes INTEGER,
        ingredients TEXT,
        instructions TEXT,
        mealType TEXT
      )
    ''');
  }

  Future<void> insertRecipes(List<Recipe> recipes) async {
    final db = await database;
    final batch = db.batch();
    for (var r in recipes) {
      batch.insert(Constants.recipesTable, {
        'id': r.id,
        'name': r.name,
        'description': r.description,
        'image': r.image,
        'cuisine': r.cuisine,
        'difficulty': r.difficulty,
        'rating': r.rating,
        'caloriesPerServing': r.caloriesPerServing,
        'cookTimeMinutes': r.cookTimeMinutes,
        'ingredients': r.ingredients.join('||'),
        'instructions': r.instructions.join('||'),
        'mealType': r.mealType.join('||'),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await database;
    final res = await db.query(Constants.recipesTable);
    return res.map((e) => Recipe(
      id: e['id'] as int,
      name: e['name'] as String,
      description: e['description'] as String,
      image: e['image'] as String,
      cuisine: e['cuisine'] as String,
      difficulty: e['difficulty'] as String,
      rating: (e['rating'] as num).toDouble(),
      caloriesPerServing: e['caloriesPerServing'] as int,
      cookTimeMinutes: e['cookTimeMinutes'] as int,
      ingredients: (e['ingredients'] as String).isEmpty ? [] : (e['ingredients'] as String).split('||'),
      instructions: (e['instructions'] as String).isEmpty ? [] : (e['instructions'] as String).split('||'),
      mealType: (e['mealType'] as String).isEmpty ? [] : (e['mealType'] as String).split('||'),
    )).toList();
  }

  Future<void> clearRecipes() async {
    final db = await database;
    await db.delete(Constants.recipesTable);
  }

  Future<void> deleteDatabaseFile() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'recipes_app.db');
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }
    } catch (e) {
      // ignore
    }
  }
}
