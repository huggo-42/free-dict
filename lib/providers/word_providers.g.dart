// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchResultsHash() => r'b5045e48a78e7e5a1973435fbc1ce5e378ff13d5';

/// See also [searchResults].
@ProviderFor(searchResults)
final searchResultsProvider = AutoDisposeFutureProvider<List<String>>.internal(
  searchResults,
  name: r'searchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchResultsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$wordDetailsHash() => r'ef361ec6125317e79e6579b194657fc38f9c5028';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [wordDetails].
@ProviderFor(wordDetails)
const wordDetailsProvider = WordDetailsFamily();

/// See also [wordDetails].
class WordDetailsFamily extends Family<AsyncValue<WordDetails?>> {
  /// See also [wordDetails].
  const WordDetailsFamily();

  /// See also [wordDetails].
  WordDetailsProvider call(
    String word,
  ) {
    return WordDetailsProvider(
      word,
    );
  }

  @override
  WordDetailsProvider getProviderOverride(
    covariant WordDetailsProvider provider,
  ) {
    return call(
      provider.word,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordDetailsProvider';
}

/// See also [wordDetails].
class WordDetailsProvider extends AutoDisposeFutureProvider<WordDetails?> {
  /// See also [wordDetails].
  WordDetailsProvider(
    String word,
  ) : this._internal(
          (ref) => wordDetails(
            ref as WordDetailsRef,
            word,
          ),
          from: wordDetailsProvider,
          name: r'wordDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$wordDetailsHash,
          dependencies: WordDetailsFamily._dependencies,
          allTransitiveDependencies:
              WordDetailsFamily._allTransitiveDependencies,
          word: word,
        );

  WordDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.word,
  }) : super.internal();

  final String word;

  @override
  Override overrideWith(
    FutureOr<WordDetails?> Function(WordDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WordDetailsProvider._internal(
        (ref) => create(ref as WordDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        word: word,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WordDetails?> createElement() {
    return _WordDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordDetailsProvider && other.word == word;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, word.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordDetailsRef on AutoDisposeFutureProviderRef<WordDetails?> {
  /// The parameter `word` of this provider.
  String get word;
}

class _WordDetailsProviderElement
    extends AutoDisposeFutureProviderElement<WordDetails?> with WordDetailsRef {
  _WordDetailsProviderElement(super.provider);

  @override
  String get word => (origin as WordDetailsProvider).word;
}

String _$searchQueryHash() => r'3c36752ee11b18a9f1e545eb1a7209a7222d91c9';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$historyHash() => r'737a8b1906f252c2aec11e44ec40f84bb943e0e1';

/// See also [History].
@ProviderFor(History)
final historyProvider =
    AutoDisposeNotifierProvider<History, List<String>>.internal(
  History.new,
  name: r'historyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$historyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$History = AutoDisposeNotifier<List<String>>;
String _$favoritesHash() => r'120dc8ebf422ea3b52463eb91a49289bca294902';

/// See also [Favorites].
@ProviderFor(Favorites)
final favoritesProvider =
    AutoDisposeNotifierProvider<Favorites, List<String>>.internal(
  Favorites.new,
  name: r'favoritesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$favoritesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Favorites = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
