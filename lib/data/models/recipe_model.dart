class Recipe {
  final int id;
  final String name;
  final String description;
  final String image;
  final String cuisine;
  final String difficulty;
  final double rating;
  final int caloriesPerServing;
  final int cookTimeMinutes;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.rating,
    required this.caloriesPerServing,
    required this.cookTimeMinutes,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      cuisine: json['cuisine'] ?? '',
      difficulty: json['difficulty'] ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      caloriesPerServing: json['caloriesPerServing'] ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] ?? 0,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      mealType: List<String>.from(json['mealType'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
        'cuisine': cuisine,
        'difficulty': difficulty,
        'rating': rating,
        'caloriesPerServing': caloriesPerServing,
        'cookTimeMinutes': cookTimeMinutes,
        'ingredients': ingredients,
        'instructions': instructions,
        'mealType': mealType,
      };
}
