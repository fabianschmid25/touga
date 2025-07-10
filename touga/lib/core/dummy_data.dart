import '../models/article.dart';

final List<Article> mockArticles = [
  Article(
    id: '1',
    title: 'The Future of AI',
    teaser: 'A quick look into what AI brings...',
    imageUrls: [
      'assets/images/article1_1.jpg',
      'assets/images/article1_2.jpg',
      'assets/images/article1_3.jpg',
    ],
    author: 'John Doe',
    views: 1234,
    likes: 320,
  ),
  Article(
    id: '2',
    title: 'Flutter Rocks!',
    teaser: 'Building apps faster than ever...',
    imageUrls: [
      'assets/images/article2_1.jpg',
      'assets/images/article2_2.jpg',
      'assets/images/article2_3.jpg',
    ],
    author: 'Jane Smith',
    views: 950,
    likes: 210,
  ),
];
