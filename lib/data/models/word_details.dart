class WordDetails {
  final String word;
  final String? phonetic;
  final List<Meaning> meanings;
  final String? audioUrl;

  WordDetails({
    required this.word,
    this.phonetic,
    required this.meanings,
    this.audioUrl,
  });

  factory WordDetails.fromJson(Map<String, dynamic> json) {
    String? audioUrl;
    if (json['phonetics'] is List && (json['phonetics'] as List).isNotEmpty) {
      for (var phonetic in json['phonetics']) {
        if (phonetic['audio'] != null &&
            phonetic['audio'].toString().isNotEmpty) {
          audioUrl = phonetic['audio'].toString();
          if (!audioUrl.startsWith('http')) {
            audioUrl = 'https:$audioUrl';
          }
          break;
        }
      }
    }

    return WordDetails(
      word: json['word'] as String,
      phonetic: json['phonetic'] as String?,
      meanings: (json['meanings'] as List<dynamic>)
          .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList(),
      audioUrl: audioUrl,
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] as String,
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Definition {
  final String definition;
  final String? example;

  Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] as String,
      example: json['example'] as String?,
    );
  }
}
