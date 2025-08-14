import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../recipes/match_engine.dart';
import '../recipes/recipe_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final have = ref.watch(userIngredientsProvider);
    final resultsAsync = ref.watch(rankedResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe from Fridge'),
        actions: [
          IconButton(
            onPressed: () => _showFilters(context, ref),
            icon: const Icon(Icons.tune),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أدخل مكوّناتك (واضغط Enter لكل عنصر):'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'مثل: بيض، طماطم، جبن...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      final v = value.trim();
                      if (v.isEmpty) return;
                      final list = [...have];
                      list.add(v);
                      ref.read(userIngredientsProvider.notifier).state = list;
                      controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    final v = controller.text.trim();
                    if (v.isEmpty) return;
                    final list = [...have];
                    list.add(v);
                    ref.read(userIngredientsProvider.notifier).state = list;
                    controller.clear();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة'),
                )
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final ing in have)
                  Chip(
                    label: Text(ing),
                    onDeleted: () {
                      final list = [...have];
                      list.remove(ing);
                      ref.read(userIngredientsProvider.notifier).state = list;
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: resultsAsync.when(
                data: (results) {
                  if (results.isEmpty) {
                    return const Center(child: Text('لا توجد نتائج. جرّب إضافة مكوّنات أخرى.'));
                  }
                  return ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final r = results[i];
                      final pct = (r.score * 100).round();
                      final subtitle = r.missing.isEmpty
                          ? 'كامل التطابق'
                          : 'ينقصك: ${r.missing.take(4).join(', ')}${r.missing.length > 4 ? '…' : ''}';
                      return ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        leading: CircleAvatar(child: Text('$pct%')),
                        title: Text(r.recipe.title),
                        subtitle: Text(subtitle),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RecipeDetailPage(result: r)),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('خطأ في تحميل الوصفات: $e')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showFilters(BuildContext context, WidgetRef ref) {
    final tagCtrl = TextEditingController();
    final exclCtrl = TextEditingController();
    final curTags = [...ref.read(includeTagsProvider)];
    final curExcl = [...ref.read(excludeIngredientsProvider)];

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مرشّحات'),
            const SizedBox(height: 12),
            const Text('ضمّن وسوم (tags):'),
            Wrap(
              spacing: 8,
              children: [
                for (final t in curTags)
                  Chip(
                    label: Text(t),
                    onDeleted: () {
                      curTags.remove(t);
                    },
                  ),
              ],
            ),
            TextField(
              controller: tagCtrl,
              decoration: const InputDecoration(hintText: 'مثال: quick, breakfast'),
              onSubmitted: (v) {
                final s = v.trim();
                if (s.isNotEmpty) curTags.add(s);
                tagCtrl.clear();
              },
            ),
            const SizedBox(height: 12),
            const Text('استبعد مكوّنات:'),
            Wrap(
              spacing: 8,
              children: [
                for (final t in curExcl)
                  Chip(
                    label: Text(t),
                    onDeleted: () {
                      curExcl.remove(t);
                    },
                  ),
              ],
            ),
            TextField(
              controller: exclCtrl,
              decoration: const InputDecoration(hintText: 'مثال: فلفل، فطر'),
              onSubmitted: (v) {
                final s = v.trim();
                if (s.isNotEmpty) curExcl.add(s);
                exclCtrl.clear();
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    ref.read(includeTagsProvider.notifier).state = curTags;
                    ref.read(excludeIngredientsProvider.notifier).state = curExcl;
                    Navigator.pop(context);
                  },
                  child: const Text('تطبيق'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}