import '../../../../core/network/dio_client.dart';

class AddRemoteDataSource {
  final DioClient _dioClient;
  AddRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> createDraft({
    required String title,
    String? subtitle,
    required String contentHtml,
    required List<String> images,
  }) async {
    final dio = _dioClient.dio;
    final resp = await dio.post(
      '/drafts',
      data: {
        'title': title,
        'subtitle': subtitle,
        'contentHtml': contentHtml,
        'images': images,
      },
    );
    return resp.data as Map<String, dynamic>;
  }

  Future<void> updateDraft({
    required String id,
    String? title,
    String? subtitle,
    String? contentHtml,
    List<String>? images,
  }) async {
    final dio = _dioClient.dio;
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (subtitle != null) body['subtitle'] = subtitle;
    if (contentHtml != null) body['contentHtml'] = contentHtml;
    if (images != null) body['images'] = images;
    await dio.patch('/drafts/$id', data: body);
  }

  Future<void> publishDraft(String id) async {
    final dio = _dioClient.dio;
    await dio.post('/drafts/$id/publish');
  }
}
