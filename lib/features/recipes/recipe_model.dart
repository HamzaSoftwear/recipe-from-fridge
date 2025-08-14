class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> steps;
  final int prepMinutes; 
  final List<String> tags; 

  const Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.prepMinutes,
    required this.tags,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        title: json['title'] as String,
        ingredients: (json['ingredients'] as List).map((e) => (e as String).toLowerCase()).toList(),
        steps: (json['steps'] as List).map((e) => e as String).toList(),
        prepMinutes: json['prepMinutes'] as int,
        tags: (json['tags'] as List).map((e) => (e as String).toLowerCase()).toList(),
      );
}

class MatchResult {
  final Recipe recipe;
  final double score; 
  final List<String> missing; 
  final Map<String, List<String>> substitutions;

  const MatchResult({
    required this.recipe,
    required this.score,
    required this.missing,
    required this.substitutions,
  });
}