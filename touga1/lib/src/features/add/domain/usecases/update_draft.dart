import '../entities/draft.dart';
import '../../data/repositories/add_repository.dart';

class UpdateDraft {
  final AddRepository repo;
  UpdateDraft(this.repo);

  Future<void> call(Draft draft) {
    return repo.updateDraft(
      id: draft.id,
      title: draft.title,
      subtitle: draft.subtitle,
      contentHtml: draft.contentHtml,
      images: draft.images,
    );
  }
}
