// lib/src/features/add/presentation/pages/editor_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../application/providers.dart';
import 'metadata_page.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key});

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  late final quill.QuillController _controller;
  late final quill.QuillSimpleToolbarConfig _toolbarConfig;
  late final quill.QuillEditorConfig _editorConfig;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController.basic();
    _toolbarConfig = const quill.QuillSimpleToolbarConfig();
    _editorConfig = const quill.QuillEditorConfig(
      placeholder: 'Schreibe hier deinen Artikel…',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPublish() async {
    // 1) Delta → JSON
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    // 2) in HTML umwandeln und in DraftController setzen + sofort updaten
    final notifier = ref.read(draftControllerProvider.notifier);
    notifier.setContentDelta(deltaJson);
    await notifier.updateCurrentDraft();
    // 3) dann Metadaten-Seite öffnen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MetadataPage(contentDelta: deltaJson),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // onExit-Autosave: ebenfalls Content flushen
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    final notifier = ref.read(draftControllerProvider.notifier);
    notifier.setContentDelta(deltaJson);
    await notifier.updateCurrentDraft();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Artikel schreiben'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _onPublish,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              quill.QuillSimpleToolbar(
                controller: _controller,
                config: _toolbarConfig,
              ),
              Expanded(
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  config: _editorConfig,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
