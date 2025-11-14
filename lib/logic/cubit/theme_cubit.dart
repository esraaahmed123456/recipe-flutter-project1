import 'package:bloc/bloc.dart';
import '../../core/shared_prefs_helper.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit(bool initialState) : super(initialState);

  Future<void> toggleTheme() async {
    final newTheme = !state;
    await SharedPrefsHelper.setDarkMode(newTheme);
    emit(newTheme);
  }
}
