import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/app_scaffold.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touga1',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const AppScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
