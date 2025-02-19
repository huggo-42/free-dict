import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../providers/word_providers.dart';
import '../data/models/word_details.dart';

class WordDetailsScreen extends ConsumerStatefulWidget {
  final String word;

  const WordDetailsScreen({
    super.key,
    required this.word,
  });

  @override
  ConsumerState<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends ConsumerState<WordDetailsScreen> {
  int _currentMeaningIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAudio = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _nextMeaning(int totalMeanings) {
    setState(() {
      _currentMeaningIndex = (_currentMeaningIndex + 1) % totalMeanings;
    });
  }

  void _previousMeaning(int totalMeanings) {
    setState(() {
      _currentMeaningIndex =
          (_currentMeaningIndex - 1 + totalMeanings) % totalMeanings;
    });
  }

  Future<void> _playAudio(String url) async {
    try {
      setState(() {
        _isPlayingAudio = true;
      });
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      await _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      );
    } finally {
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final wordDetailsAsync = ref.watch(wordDetailsProvider(widget.word));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      body: wordDetailsAsync.when(
        data: (WordDetails? details) {
          if (details == null) {
            return const Center(
              child: Text('Word not found'),
            );
          }
          final meaning = details.meanings[_currentMeaningIndex];
          final definition = meaning.definitions.first;

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            details.word,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (details.phonetic != null)
                            Text(
                              details.phonetic!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                            ),
                          const SizedBox(height: 16),
                          if (details.audioUrl != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: IconButton.filled(
                                onPressed: _isPlayingAudio
                                    ? null
                                    : () => _playAudio(details.audioUrl!),
                                icon: Icon(
                                  _isPlayingAudio
                                      ? Icons.volume_up
                                      : Icons.volume_up_outlined,
                                  size: 28,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: _isPlayingAudio
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.5)
                                      : colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < details.meanings.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _currentMeaningIndex = i;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: i == _currentMeaningIndex
                                          ? colorScheme.primary
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      details.meanings[i].partOfSpeech,
                                      style: TextStyle(
                                        color: i == _currentMeaningIndex
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 240,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Meanings',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Definition:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                definition.definition,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (definition.example != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'Example:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '"${definition.example!}"',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: colorScheme.secondary,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _currentMeaningIndex > 0
                                ? () =>
                                    _previousMeaning(details.meanings.length)
                                : null,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Previous'),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${_currentMeaningIndex + 1}/${details.meanings.length}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: _currentMeaningIndex <
                                    details.meanings.length - 1
                                ? () => _nextMeaning(details.meanings.length)
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
