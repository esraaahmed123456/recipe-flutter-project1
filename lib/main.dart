import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_theme.dart';
import 'core/dio_client.dart';
import 'data/repositories/recipe_repository.dart';
import 'logic/cubit/recipe_cubit.dart';
import 'logic/cubit/theme_cubit.dart';
import 'logic/cubit/favorites_cubit.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/about_screen.dart';
import 'presentation/screens/welcome_screen.dart';
import 'core/shared_prefs_helper.dart';
import 'data/local/database_provider.dart';
import 'presentation/screens/shopping_list_screen.dart';

import 'presentation/screens/register_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbProvider = DatabaseProvider();
  await dbProvider.deleteDatabaseFile();
  await dbProvider.database;

  final isDark = await SharedPrefsHelper.isDarkMode();
  final favoriteIds = await SharedPrefsHelper.getFavoriteIds();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(isDark)),
        BlocProvider<FavoritesCubit>(
            create: (_) => FavoritesCubit(favoriteIds)),
        BlocProvider<RecipeCubit>(
            create: (_) => RecipeCubit(repository: RecipeRepository())),
      ],
      child: const RecipesApp(),
    ),
  );
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return MaterialApp(
          title: 'Recipes App',
          debugShowCheckedModeBanner: false,
          theme: isDark ? darkTheme : lightTheme,
          initialRoute: '/welcome',
          routes: {
            '/welcome': (_) => const WelcomeScreen(),
            '/': (_) => const HomeScreen(),
            '/favorites': (_) => const FavoritesScreen(),
            '/settings': (_) => const SettingsScreen(),
              '/shopping': (_) => const ShoppingListScreen(),
            '/about': (_) => const AboutScreen(),
            '/register': (_) => const RegisterScreen(),

          },
        );
      },
    );
  }
}
