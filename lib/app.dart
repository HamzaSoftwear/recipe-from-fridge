import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home/home_page.dart';

class RecipeFromFridgeApp extends StatelessWidget {
  const RecipeFromFridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe from Fridge',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}