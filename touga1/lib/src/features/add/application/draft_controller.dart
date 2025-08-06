// lib/src/features/add/application/draft_controller.dart

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../domain/entities/draft.dart';
import '../domain/usecases/create_draft.dart';
import '../domain/usecases/update_draft.dart';
import '../domain/usecases/publish_draft.dart';

class DraftController extends StateNotifier<AsyncValue<void>> {
  DraftController({
    required CreateDraft create,
    required UpdateDraft update,
    required PublishDraft publish,
  })  : _create = create,
        _update = update,
        _publish = publish,
        super(const AsyncValue.data(null)) {
    _init();
  }

  final CreateDraft _create;
  final UpdateDraft _update;
  final PublishDraft _publish;

  Draft? _draft;
  Draft? get draft => _draft;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    try {
      final initialHtml = '<p><br></p>';
      _draft = await _create(
        title: '',
        subtitle: null,
        contentHtml: initialHtml,
        images: [],
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // ——— Setter für die Felder ———

  void updateTitle(String title) => _updateField(title: title);
  void updateSubtitle(String subtitle) => _updateField(subtitle: subtitle);
  void updateContentHtml(String html) => _updateField(contentHtml: html);
  void updateImages(List<String> images) => _updateField(images: images);

  void setContentDelta(String deltaJson) {
    final ops = List<Map<String, dynamic>>.from(jsonDecode(deltaJson));
    final converter = QuillDeltaToHtmlConverter(
      ops,
      ConverterOptions(),
    );
    final html = converter.convert();
    updateContentHtml(html);
  }

  void setTitle(String title) => updateTitle(title);
  void setSubtitle(String subtitle) => updateSubtitle(subtitle);

  void _updateField({
    String? title,
    String? subtitle,
    String? contentHtml,
    List<String>? images,
  }) {
    if (_draft == null) return;
    _draft = Draft(
      id: _draft!.id,
      title: title ?? _draft!.title,
      subtitle: subtitle ?? _draft!.subtitle,
      contentHtml: contentHtml ?? _draft!.contentHtml,
      images: images ?? _draft!.images,
    );
  }

  ///  ——— Neuer Flush-Call, wird nur manuell aufgerufen ———
  Future<void> updateCurrentDraft() async {
    if (_draft == null) return;
    await _update(_draft!);
  }

  /// ——— Publish-Flow: erst Flush, dann Publish ———
  Future<void> publish() async {
    if (_draft == null) return;
    state = const AsyncValue.loading();
    try {
      // 1) alle Änderungen synchron zum Backend pushen
      await updateCurrentDraft();
      // 2) erst danach den Article-Publish-UseCase ausführen
      await _publish(_draft!);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
