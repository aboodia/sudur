import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/bookmarks_list_view.dart';
import 'widgets/juz_list_view.dart';
import 'widgets/surah_list_view.dart';

/// Accueil lecture (Brique 1) : onglets Sourates / Juz / Signets.
class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  void _openSurah(BuildContext context, int surahNumber, {int? startAyah}) {
    final query = startAyah != null ? '?ayah=$startAyah' : '';
    context.push('/lecture/sourate/$surahNumber$query');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lecture'),
          bottom: const TabBar(tabs: [
            Tab(text: 'Sourates'),
            Tab(text: 'Juz'),
            Tab(text: 'Signets'),
          ]),
        ),
        body: TabBarView(children: [
          SurahListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, n, startAyah: startAyah)),
          JuzListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, n, startAyah: startAyah)),
          BookmarksListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, n, startAyah: startAyah)),
        ]),
      ),
    );
  }
}
