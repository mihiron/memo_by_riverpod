import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_by_riverpod/repositories/local/local_repository_provider.dart';
import 'package:memo_by_riverpod/services/local/app_database.dart';
import 'package:memo_by_riverpod/views/home_page.dart';

final databaseProvider = Provider<AppDatabase>(
  (ref) {
    final appDatabase = AppDatabase();
    return appDatabase;
  },
);

final localRepoProvider = Provider<LocalRepositoryProvider>(
  (ref) => LocalRepositoryProvider(ref.watch(databaseProvider)),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(),
    );
  }
}
