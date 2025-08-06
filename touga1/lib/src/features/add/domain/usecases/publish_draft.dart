import '../entities/draft.dart';
import '../../data/repositories/add_repository.dart';

class PublishDraft {
  final AddRepository repo;
  PublishDraft(this.repo);

  Future<void> call(Draft draft) {
    return repo.publishDraft(draft.id);
  }
}
