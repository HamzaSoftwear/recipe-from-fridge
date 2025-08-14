import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipe_model.dart';

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final raw = await rootBundle.loadString('assets/recipes.json');
  final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  return list.map(Recipe.fromJson).toList(growable: false);
});

final substitutionsProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final raw = await rootBundle.loadString('assets/substitutions.json');
  final map = (jsonDecode(raw) as Map<String, dynamic>);
  return map.map((k, v) => MapEntry(k.toLowerCase(), (v as List).map((e) => (e as String).toLowerCase()).toList()));
});