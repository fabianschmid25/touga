import '../datasources/add_remote_datasource.dart';

class AddRepository {
  final AddRemoteDataSource remote;
  AddRepository(this.remote);

  /// Erstellt einen Draft und liefert die neue ID zurück
  Future<String> createDraft({
    required String title,
    String? subtitle,
    required String contentHtml,
    required List<String> images,
  }) async {
    final data = await remote.createDraft(
      title: title,
      subtitle: subtitle,
      contentHtml: contentHtml,
      images: images,
    );
    return data['id'] as String;
  }

  Future<void> updateDraft({
    required String id,
    String? title,
    String? subtitle,
    String? contentHtml,
    List<String>? images,
  }) => remote.updateDraft(
    id: id,
    title: title,
    subtitle: subtitle,
    contentHtml: contentHtml,
    images: images,
  );

  Future<void> publishDraft(String id) => remote.publishDraft(id);
}
