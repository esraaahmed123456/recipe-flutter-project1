import 'package:bloc/bloc.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository repository;
  RecipeCubit({required this.repository}) : super(RecipeInitial());

  Future<void> loadRecipes({bool force = false}) async {
    try {
      emit(RecipeLoading());
      final recipes = await repository.fetchRecipes(forceRefresh: force);
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}
