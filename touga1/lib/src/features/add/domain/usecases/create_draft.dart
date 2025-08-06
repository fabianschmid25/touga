// lib/src/features/add/domain/usecases/create_draft.dart

import '../entities/draft.dart';
import '../../data/repositories/add_repository.dart';

class CreateDraft {
  final AddRepository repo;
  CreateDraft(this.repo);

  Future<Draft> call({
    required String title,
    String? subtitle,
    required String contentHtml,
    required List<String> images,
  }) async {
    // Repository returns the new draft id
    final id = await repo.createDraft(
      title: title,
      subtitle: subtitle,
      contentHtml: contentHtml,
      images: images,
    );
    return Draft(
      id: id,
      title: title,
      subtitle: subtitle,
      contentHtml: contentHtml,
      images: images,
    );
  }
}
