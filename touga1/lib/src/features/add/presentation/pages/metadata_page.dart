// lib/src/features/add/presentation/pages/metadata_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';

class MetadataPage extends ConsumerStatefulWidget {
  const MetadataPage({
    super.key,
    required this.contentDelta,
  });

  /// Das Quill-Delta JSON aus dem Editor
  final String contentDelta;

  @override
  ConsumerState<MetadataPage> createState() => _MetadataPageState();
}

class _MetadataPageState extends ConsumerState<MetadataPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    // Content in HTML umwandeln und in den Controller setzen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(draftControllerProvider.notifier)
          .setContentDelta(widget.contentDelta);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _onPublish() async {
    setState(() => _isPublishing = true);
    final notifier = ref.read(draftControllerProvider.notifier);

    // 1) Metadaten setzen
    notifier.setTitle(_titleController.text);
    notifier.setSubtitle(_subtitleController.text);
    // (Falls du Images hast: notifier.updateImages(...);)

    // 2) Flush aller aktuellen Draft-Felder
    await notifier.updateCurrentDraft();

    // 3) Artikel wirklich veröffentlichen
    await notifier.publish();

    if (!mounted) return;
    // 4) Erst Metadaten-Seite schließen
    Navigator.of(context).pop();
    // 5) Dann EditorPage schließen und zurück zum Feed
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel-Metadaten')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitel'),
            ),
            const Spacer(),
            _isPublishing
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.publish),
                    label: const Text('Veröffentlichen'),
                    onPressed: _onPublish,
                  ),
          ],
        ),
      ),
    );
  }
}
