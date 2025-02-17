import 'package:free_dict/data/models/word_details.dart';

class Cache {
  final Map<String, WordDetails> _cacheData = {};

  void addData(String key, WordDetails value) {
    _cacheData[key] = value;
  }

  WordDetails? getData(String key) {
    return _cacheData[key];
  }

  void clearCache() {
    _cacheData.clear();
  }
}
