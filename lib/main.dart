import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'infra/database/database_helper.dart';
import 'infra/di/di.dart';
import 'presentation/login_screen.dart';

void main() async {
  await setupDependencyInjection();
  final dbHelper = locator<DatabaseHelper>();
  await dbHelper.initializeWordsFromJson();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
