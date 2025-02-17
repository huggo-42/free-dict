import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/word_details_screen.dart';
import '../providers/word_providers.dart';

class WordItem extends ConsumerWidget {
  final String word;

  const WordItem({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider.notifier).isFavorite(word);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: InkWell(
        onTap: () {
          ref.read(historyProvider.notifier).addToHistory(word);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WordDetailsScreen(word: word),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  word,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(word);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
