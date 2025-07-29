// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/app_scaffold.dart';
import 'src/features/auth/presentation/login_page.dart';
import 'src/features/auth/domain/auth_provider.dart';
import 'src/features/auth/domain/auth_state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Lausche auf Statuswechsel und navigiere nach Authentifizierung
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        // Navigation erst nach Frame-Ende, um Build-Konflikte zu vermeiden
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
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      );
    }

    // Authenticated → direkt das Scaffold (wird aber meist per pushReplacement erreicht)
    return const MaterialApp(
      home: AppScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
