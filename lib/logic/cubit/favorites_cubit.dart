import 'package:bloc/bloc.dart';
import '../../core/shared_prefs_helper.dart';

class FavoritesCubit extends Cubit<List<String>> {
  FavoritesCubit(List<String> initial) : super(initial);

  Future<void> addFavorite(String id) async {
    final newList = [...state];
    if (!newList.contains(id)) {
      newList.add(id);
      await SharedPrefsHelper.saveFavoriteIds(newList);
      emit(newList);
    }
  }

  Future<void> removeFavorite(String id) async {
    final newList = state.where((e) => e != id).toList();
    await SharedPrefsHelper.saveFavoriteIds(newList);
    emit(newList);
  }

  bool isFavorite(String id) => state.contains(id);
}
