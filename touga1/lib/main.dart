// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Für Quill-Übersetzungen
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart'
    show FlutterQuillLocalizations;

import 'src/core/app_scaffold.dart';
import 'src/features/auth/presentation/login_page.dart';
import 'src/features/auth/domain/auth_provider.dart';
import 'src/features/auth/domain/auth_state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // Gemeinsame Delegates & Locales für alle MaterialApps
  static const _localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    FlutterQuillLocalizations.delegate,
  ];
  static const _supportedLocales = <Locale>[
    Locale('en'), // Englisch
    Locale('de'), // Deutsch
    // Weitere Sprachen hier hinzufügen, falls gewünscht
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Lausche auf Statuswechsel und navigiere nach Authentifizierung
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppScaffold()),
          );
        });
      }
    });

    // Solange geladen wird, Spinner zeigen
    if (authState.status == AuthStatus.loading) {
      return const MaterialApp(
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: _supportedLocales,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // Unauthenticated → LoginPage
    if (authState.status != AuthStatus.authenticated) {
      return const MaterialApp(
        localizationsDelegates: _localizationsDelegates,
        supportedLocales: _supportedLocales,
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      );
    }

    // Authenticated → AppScaffold (häufig per pushReplacement)
    return const MaterialApp(
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: _supportedLocales,
      home: AppScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
