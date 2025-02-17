import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/cache.dart';
import '../infra/database/database_helper.dart';
import '../infra/di/di.dart';
import '../providers/word_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/word_item.dart';
import 'login_screen.dart';

class WordsScreen extends ConsumerStatefulWidget {
  const WordsScreen({super.key});

  @override
  ConsumerState<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends ConsumerState<WordsScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _dbHelper = locator<DatabaseHelper>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _words = [];
  bool _isLoading = false;
  bool _showScrollToTop = false;
  static const int _pageSize = 50;
  int _currentOffset = 0;
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMoreWords();
    _scrollController.addListener(_onScroll);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreWords() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newWords =
          await _dbHelper.getWordsPaginated(_currentOffset, _pageSize);
      setState(() {
        _words.addAll(newWords);
        _currentOffset += newWords.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading words: $e')),
        );
      }
    }
  }

  void _onScroll() {
    final showScrollToTop = _scrollController.offset > 1000;
    if (showScrollToTop != _showScrollToTop) {
      setState(() {
        _showScrollToTop = showScrollToTop;
      });
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _loadMoreWords();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search words...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).setQuery('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor:
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).setQuery(value);
        },
      ),
    );
  }

  Widget _buildWordList() {
    final query = ref.watch(searchQueryProvider);

    if (query.isNotEmpty) {
      return ref.watch(searchResultsProvider).when(
            data: (words) {
              if (words.isEmpty) {
                return const Center(
                  child: Text('No words found'),
                );
              }
              return ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return WordItem(word: words[index]);
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _words.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _words.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return WordItem(word: _words[index]);
      },
    );
  }

  Widget _buildHistoryList() {
    final history = ref.watch(historyProvider);

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing added yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Words you look up will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: WordItem(word: history[index]),
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing added yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon to save your favorite words',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: WordItem(word: favorites[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider);

    bool shouldShowScrollToTop =
        (_selectedTabIndex == TabIndexes.wordList.index) && _showScrollToTop;
    bool shouldShowClearHistory =
        _selectedTabIndex == TabIndexes.history.index &&
            ref.watch(historyProvider).isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        backgroundColor: colorScheme.surfaceVariant,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user?.username ?? '',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 20),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Word List'),
            Tab(text: 'History'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWordList(),
                _buildHistoryList(),
                _buildFavoritesList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: shouldShowScrollToTop
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              tooltip: 'Scroll to top',
              child: const Icon(Icons.keyboard_arrow_up),
            )
          : shouldShowClearHistory
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear History'),
                        content: const Text(
                            'Are you sure you want to clear your history? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(historyProvider.notifier).clearHistory();
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  },
                  tooltip: 'Clear History',
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                )
              : null,
    );
  }
}

enum TabIndexes {
  wordList,
  history,
  favorites,
}
