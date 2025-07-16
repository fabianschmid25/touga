// lib/src/article_page.dart

import 'package:flutter/material.dart';
import 'package:touga1/src/features/feed/domain/entities/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;
  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          article.content,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
