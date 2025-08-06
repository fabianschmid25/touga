class Draft {
  final String id;
  final String title;
  final String? subtitle;
  final String contentHtml;
  final List<String> images;

  Draft({
    required this.id,
    required this.title,
    this.subtitle,
    required this.contentHtml,
    required this.images,
  });
}
