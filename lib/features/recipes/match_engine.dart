import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipe_model.dart';
import 'recipe_repo.dart';

final userIngredientsProvider = StateProvider<List<String>>((ref) => <String>[]);
final includeTagsProvider = StateProvider<List<String>>((ref) => <String>[]);
final excludeIngredientsProvider = StateProvider<List<String>>((ref) => <String>[]);

final matcherProvider = Provider<Matcher>((ref) {
  final subsAsync = ref.watch(substitutionsProvider);
  return Matcher(subsAsync.value ?? const {});
});

class Matcher {
  final Map<String, List<String>> substitutions; // egg -> [flax egg, yogurt]
  const Matcher(this.substitutions);

  /// يحسب نتيجة تطابق بين مكونات المستخدم ووصفة معيّنة.
  MatchResult match(Recipe recipe, List<String> have, {List<String> exclude = const []}) {
    final haveSet = have.map(_norm).toSet();
    final req = recipe.ingredients.map(_norm).toList();

    // إزالة المستبعدات الصريحة
    final filteredReq = req.where((ing) => !exclude.contains(ing)).toList();

    // مطابقة مباشرة
    int directHits = filteredReq.where(haveSet.contains).length;

    // مطابقة بالبدائل
    int subHits = 0;
    final missing = <String>[];
    final usedSubs = <String, List<String>>{};

    for (final need in filteredReq) {
      if (haveSet.contains(need)) continue;
      final subs = substitutions[need] ?? const [];
      final found = subs.firstWhereOrNull(haveSet.contains);
      if (found != null) {
        subHits += 1;
        usedSubs[need] = [found];
      } else {
        missing.add(need);
      }
    }

    final total = filteredReq.length;
    final score = total == 0 ? 0.0 : (directHits * 1.0 + subHits * 0.7) / total; // بديل أقل وزنًا

    return MatchResult(
      recipe: recipe,
      score: score.clamp(0, 1),
      missing: missing,
      substitutions: usedSubs,
    );
  }

  String _norm(String s) => s.trim().toLowerCase();
}

final rankedResultsProvider = FutureProvider<List<MatchResult>>((ref) async {
  final recipes = await ref.watch(recipesProvider.future);
  final have = ref.watch(userIngredientsProvider).map((e) => e.toLowerCase()).toList();
  final exclude = ref.watch(excludeIngredientsProvider).map((e) => e.toLowerCase()).toList();
  final includeTags = ref.watch(includeTagsProvider).map((e) => e.toLowerCase()).toList();

  final matcher = ref.watch(matcherProvider);

  final results = <MatchResult>[];
  for (final r in recipes) {
    if (includeTags.isNotEmpty && !includeTags.any(r.tags.contains)) continue;
    results.add(matcher.match(r, have, exclude: exclude));
  }

  results.sort((a, b) => b.score.compareTo(a.score));
  return results;
});