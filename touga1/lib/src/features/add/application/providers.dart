import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/datasources/add_remote_datasource.dart';
import '../data/repositories/add_repository.dart';
import '../domain/usecases/create_draft.dart';
import '../domain/usecases/update_draft.dart';
import '../domain/usecases/publish_draft.dart';
import 'draft_controller.dart';

/// 1) DioClient (global)
final dioClientProvider = Provider((ref) => DioClient());

/// 2) Remote DataSource
final addRemoteDataSourceProvider = Provider(
  (ref) => AddRemoteDataSource(ref.read(dioClientProvider)),
);

/// 3) Repository
final addRepositoryProvider = Provider(
  (ref) => AddRepository(ref.read(addRemoteDataSourceProvider)),
);

/// 4) UseCases
final createDraftProvider = Provider(
  (ref) => CreateDraft(ref.read(addRepositoryProvider)),
);
final updateDraftProvider = Provider(
  (ref) => UpdateDraft(ref.read(addRepositoryProvider)),
);
final publishDraftProvider = Provider(
  (ref) => PublishDraft(ref.read(addRepositoryProvider)),
);

/// 5) Controller (StateNotifier)
final draftControllerProvider =
    StateNotifierProvider<DraftController, AsyncValue<void>>(
      (ref) => DraftController(
        create: ref.read(createDraftProvider),
        update: ref.read(updateDraftProvider),
        publish: ref.read(publishDraftProvider),
      ),
    );
