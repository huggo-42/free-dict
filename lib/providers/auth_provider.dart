import 'package:free_dict/infra/repository/account_repository.dart';
import 'package:free_dict/utils/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/account_model.dart';
import '../infra/database/database_helper.dart';
import '../infra/di/di.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState? build() {
    return AuthState(
      userId: null,
      username: '',
      isLoggedIn: false,
    );
  }

  void set({
    int? userId,
    String? username,
    bool? isLoggedIn,
  }) {
    state = AuthState(
      userId: userId ?? state?.userId,
      username: username ?? state?.username,
      isLoggedIn: isLoggedIn ?? state?.isLoggedIn,
    );
  }

  Future<AuthState?> login(String username, String password) async {
    try {
      final dbHelper = locator<DatabaseHelper>();
      final user = await dbHelper.getUser(username, password);
      if (user == null) return null;
      return AuthState(
        userId: user['id'],
        username: user['username'],
        isLoggedIn: true,
      );
    } catch (e) {
      return null;
    }
  }

  Future<int?> signup(String username, String password) async {
    try {
      final accountRepository = locator<AccountRepository>();
      final accountId = await accountRepository.saveAccount(Account(
        username: username,
        password: password,
      ));
      if (accountId == null) return null;
      final account = await accountRepository.getAccountById(accountId);
      if (account == null) return null;
      state = AuthState(
        userId: account.id,
        username: account.username,
        isLoggedIn: true,
      );
      log(LogLevel.warning, 'auth_provider signup -> UserID $accountId');
      return accountId;
    } catch (e) {
      log(LogLevel.error, 'auth_provider Error creating account: $e');
      return null;
    }
  }

  void logout() {
    state = AuthState(
      userId: null,
      username: '',
      isLoggedIn: false,
    );
  }
}

class AuthState {
  int? userId;
  String? username;
  bool? isLoggedIn;

  AuthState({
    this.userId,
    this.username,
    this.isLoggedIn = false,
  });

  @override
  String toString() {
    return 'AuthState(userId: $userId, username: $username, isLoggedIn: $isLoggedIn)';
  }
}
