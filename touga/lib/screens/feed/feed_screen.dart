import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/feed_provider.dart';
import '../../models/article.dart';
import 'article_detail_screen.dart';

class FeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Touga Feed'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ArticleDetailScreen(article: article),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  article.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: article.imageUrls.map((imageUrl) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.asset(
                        imageUrl,
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(article.teaser),
                SizedBox(height: 10),
                Text("Author: ${article.author}"),
                Text("Views: ${article.views} • Likes: ${article.likes}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
