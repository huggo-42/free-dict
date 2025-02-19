import '../../data/models/account_model.dart';
import '../../infra/di/di.dart';
import '../database/database_helper.dart';

abstract class AccountRepository {
  Future<int?> saveAccount(Account account);
  Future<Account?> getAccountById(int accountId);
}

class AccountRepositoryDatabase implements AccountRepository {
  final _database = locator<DatabaseHelper>();

  @override
  Future<int?> saveAccount(Account account) async {
    return await _database.saveAccount(account);
  }

  @override
  Future<Account?> getAccountById(int accountId) async {
    return await _database.getAccountById(accountId);
  }
}
