import 'package:flutter/material.dart';
import '../../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...article.imageUrls.map(
              (imageUrl) => Image.asset(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                article.teaser,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              "Author: ${article.author}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Views: ${article.views} • Likes: ${article.likes}"),
          ],
        ),
      ),
    );
  }
}
