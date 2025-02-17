import 'package:free_dict/data/datasources/cache.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import '../../../database/database_helper.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();

  locator.registerLazySingleton(() => DatabaseHelper());
  locator.registerLazySingleton(() => Cache());
}
