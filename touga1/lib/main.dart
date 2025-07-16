import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/features/feed/presentation/pages/feed_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touga1 Artikel‑Feed',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const FeedPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
