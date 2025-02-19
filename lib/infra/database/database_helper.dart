import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/models/account_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'free_dict.db';

  static const String userTable = 'users';
  static const String wordsTable = 'words';
  static const String favoritesTable = 'favorites';
  static const String historyTable = 'history';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $userTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE $wordsTable (
      word TEXT PRIMARY KEY
    )
  ''');
    await db.execute('''
    CREATE TABLE $favoritesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      word TEXT,
      FOREIGN KEY (user_id) REFERENCES $userTable (id),
      FOREIGN KEY (word) REFERENCES $wordsTable (word)
    )
  ''');
    await db.execute('''
    CREATE TABLE $historyTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      word TEXT,
      FOREIGN KEY (user_id) REFERENCES $userTable (id),
      FOREIGN KEY (word) REFERENCES $wordsTable (word)
      CONSTRAINT unique_user_word UNIQUE (user_id, word)
    )
  ''');
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    final List<Map<String, dynamic>> result = await db.query(
      userTable,
      where: 'username = ? AND password = ?',
      whereArgs: [username, passwordHash],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    try {
      final user = await db.query(
        userTable,
        where: 'username = ? AND password = ?',
        whereArgs: [username, passwordHash],
        limit: 1,
      );
      return user.first;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int userId) async {
    final db = await database;
    try {
      final user = await db.query(
        userTable,
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      return user.first;
    } catch (e) {
      return null;
    }
  }

  Future<int?> createUser(String username, String password) async {
    final db = await database;
    final passwordHash = sha256.convert(utf8.encode(password)).toString();
    try {
      return await db.insert(userTable, {
        'username': username,
        'password': passwordHash,
      });
    } catch (e) {
      return null;
    }
  }

  Future<int?> saveAccount(Account account) async {
    try {
      final db = await database;
      final passwordHash =
          sha256.convert(utf8.encode(account.password)).toString();
      final userId = await db.insert(userTable, {
        'username': account.username,
        'password': passwordHash,
      });
      return userId;
    } catch (e) {
      return null;
    }
  }

  Future<Account?> getAccountById(int accountId) async {
    final db = await database;
    try {
      final user = await db.query(
        userTable,
        where: 'id = ?',
        whereArgs: [accountId],
        limit: 1,
      );
      return Account.fromMap(user.first);
    } catch (e) {
      return null;
    }
  }

  Future<void> initializeWordsFromJson() async {
    final db = await database;
    final String jsonString = await rootBundle.loadString(
      'assets/words_dictionary.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<String> words = jsonMap.keys.toList();
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final word in words) {
        batch.insert(
          wordsTable,
          {'word': word},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<String>> searchWords(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      wordsTable,
      where: 'word LIKE ?',
      whereArgs: ['$query%'],
      limit: 20,
    );
    return results.map((result) => result['word'] as String).toList();
  }

  Future<List<String>> getFavorites(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT word FROM $favoritesTable
      WHERE user_id = ?
      ORDER BY word
    ''', [userId]);
    return results.map((result) => result['word'] as String).toList();
  }

  Future<void> toggleFavorite(String word, int userId) async {
    final db = await database;
    final isFavorite = await _isWordFavorite(word, userId);
    if (isFavorite) {
      await db.delete(
        favoritesTable,
        where: 'user_id = ? AND word = ?',
        whereArgs: [userId, word],
      );
    } else {
      await db.insert(favoritesTable, {
        'user_id': userId,
        'word': word,
      });
    }
  }

  Future<bool> _isWordFavorite(String word, int userId) async {
    final db = await database;
    final result = await db.query(
      favoritesTable,
      where: 'user_id = ? AND word = ?',
      whereArgs: [userId, word],
    );
    return result.isNotEmpty;
  }

  Future<List<String>> getHistory(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT word FROM $historyTable
      WHERE user_id = ?
    ''', [userId]);
    return results.map((result) => result['word'] as String).toList();
  }

  Future<void> addToHistory(String word, int userId) async {
    final db = await database;
    await db.rawInsert('''
    INSERT OR IGNORE INTO $historyTable (user_id, word)
    VALUES (?, ?)
  ''', [userId, word]);
  }

  Future<void> clearHistory(int userId) async {
    final db = await database;
    await db.delete(
      historyTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<String>> getWordsPaginated(int offset, int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      wordsTable,
      offset: offset,
      limit: limit,
    );
    return results.map((result) => result['word'] as String).toList();
  }
}
