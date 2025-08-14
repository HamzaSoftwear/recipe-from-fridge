🍳 Recipe from Fridge

A simple offline Flutter app that helps you find recipes based on the ingredients you have in your kitchen.
Works on both mobile and web, using local JSON files as the recipe database.

✨ Features

Search recipes based on available ingredients.

Shows the percentage of available vs. missing ingredients for each recipe.

Arabic recipe names and instructions.

Large database (900+ recipes) including main dishes, desserts, soups, chicken, and meat dishes.

Works without internet (offline data).

📂 Project Structure

lib/
 ├── main.dart                # Application entry point
 ├── models/
 │    └── recipe.dart         # Recipe data model
 ├── pages/
 │    ├── home_page.dart      # Main ingredient input and recipe list
 │    └── recipe_detail.dart  # Recipe detail page
 ├── providers/
 │    └── recipe_provider.dart # State management (Riverpod)
 ├── services/
 │    └── recipe_service.dart # Load and filter recipes
 └── widgets/
      └── ingredient_input.dart # UI for adding/removing ingredients
assets/
 ├── recipes.json             # Main recipe database
 └── substitutions.json       # Ingredient substitution database
pubspec.yaml                  # Dependencies & asset configuration
README.md                     # Project documentation
