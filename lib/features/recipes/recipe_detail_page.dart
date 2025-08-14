import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final MatchResult result;
  const RecipeDetailPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final r = result.recipe;
    return Scaffold(
      appBar: AppBar(title: Text(r.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Chip(label: Text('التحضير ~ ${r.prepMinutes} د')),
              const SizedBox(width: 8),
              for (final tag in r.tags)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(label: Text(tag)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (result.missing.isNotEmpty) ...[
            Text('ينقصك:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: result.missing.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (result.substitutions.isNotEmpty) ...[
            Text('بدائل مقترحة:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            ...result.substitutions.entries.map((e) => ListTile(
                  title: Text('بدل ${e.key} بـ: ${e.value.join(', ')}'),
                )),
            const SizedBox(height: 12),
          ],
          Text('المكوّنات', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...r.ingredients.map((ing) => Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ing)),
                ],
              )),
          const SizedBox(height: 16),
          Text('الخطوات', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...r.steps.asMap().entries.map((e) => ListTile(
                leading: CircleAvatar(child: Text('${e.key + 1}')),
                title: Text(e.value),
              )),
        ],
      ),
    );
  }
}