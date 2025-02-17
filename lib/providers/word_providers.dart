import 'package:free_dict/data/datasources/cache.dart';
import 'package:free_dict/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../infra/database/database_helper.dart';
import '../infra/di/di.dart';
import 'auth_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/word_details.dart';

part 'word_providers.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
Future<List<String>> searchResults(SearchResultsRef ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final dbHelper = locator<DatabaseHelper>();
  return dbHelper.searchWords(query);
}

@riverpod
class History extends _$History {
  @override
  List<String> build() {
    ref.watch(authProvider);
    _loadHistory();
    return [];
  }

  Future<void> _loadHistory() async {
    final user = ref.read(authProvider);
    if (user?.userId == null) return;
    final dbHelper = locator<DatabaseHelper>();
    final history = await dbHelper.getHistory(user!.userId!);
    state = history;
  }

  Future<void> addToHistory(String word) async {
    final user = ref.read(authProvider);
    if (user?.userId == null) return;
    final dbHelper = locator<DatabaseHelper>();
    await dbHelper.addToHistory(word, user!.userId!);
    await _loadHistory();
  }

  Future<void> clearHistory() async {
    final user = ref.read(authProvider);
    if (user?.userId == null) return;
    final dbHelper = locator<DatabaseHelper>();
    await dbHelper.clearHistory(user!.userId!);
    await _loadHistory();
  }
}

@riverpod
class Favorites extends _$Favorites {
  @override
  List<String> build() {
    ref.watch(authProvider);
    _loadFavorites();
    return [];
  }

  Future<void> _loadFavorites() async {
    final user = ref.read(authProvider);
    if (user?.userId == null) return;
    final dbHelper = locator<DatabaseHelper>();
    final favorites = await dbHelper.getFavorites(user!.userId!);
    state = favorites;
  }

  Future<void> toggleFavorite(String word) async {
    final user = ref.read(authProvider);
    if (user?.userId == null) return;
    final dbHelper = locator<DatabaseHelper>();
    await dbHelper.toggleFavorite(word, user!.userId!);
    await _loadFavorites();
  }

  bool isFavorite(String word) => state.contains(word);
}

@riverpod
Future<WordDetails?> wordDetails(WordDetailsRef ref, String word) async {
  final cache = locator<Cache>();
  final cachedData = cache.getData(word);
  if (cachedData != null) {
    return cachedData;
  }
  final response = await http.get(
    Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
  );
  WordDetails? result;
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    if (jsonList.isNotEmpty) {
      result = WordDetails.fromJson(jsonList[0]);
    }
    cache.addData(word, result!);
  }
  return result;
}
