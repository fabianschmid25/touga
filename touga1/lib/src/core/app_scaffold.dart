import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touga1/src/features/feed/presentation/pages/feed_page.dart';
import 'package:touga1/src/features/search/presentation/pages/search_page.dart';
import 'package:touga1/src/features/add/presentation/pages/add_page.dart';
import 'package:touga1/src/features/inbox/presentation/pages/inbox_page.dart';
import 'package:touga1/src/features/profile/presentation/pages/profile_page.dart';

/// Basis-Scaffold mit BottomNavigationBar (weiß, icon-only)
class AppScaffold extends ConsumerStatefulWidget {
  const AppScaffold({Key? key}) : super(key: key);

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  int _currentIndex = 0;

  final _tabs = const [
    FeedPage(),
    SearchPage(),
    AddPage(),
    InboxPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],

      // zarte obere Hairline via DecoratedBox
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: const Color(0xFF111827),
          unselectedItemColor: const Color(0xFF64748B),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ''),
          ],
        ),
      ),
    );
  }
}
