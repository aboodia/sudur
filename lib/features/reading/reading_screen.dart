import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/mushaf/mushaf_repository.dart';
import 'widgets/bookmarks_list_view.dart';
import 'widgets/juz_list_view.dart';
import 'widgets/surah_list_view.dart';

/// Accueil lecture (Brique 1) : onglets Sourates / Juz / Signets.
class ReadingScreen extends ConsumerWidget {
  const ReadingScreen({super.key});

  /// Le mode Mushaf (pagination fidèle à l'imprimé) est la vue par défaut
  /// à l'ouverture d'une sourate — la lecture continue (avec traduction)
  /// reste accessible depuis un bouton dans la vue Mushaf.
  Future<void> _openSurah(
    BuildContext context,
    WidgetRef ref,
    int surahNumber, {
    int? startAyah,
  }) async {
    final mushaf = await ref.read(mushafRepositoryProvider.future);
    final page = mushaf.pageForAyah(surahNumber, startAyah ?? 1) ?? 1;
    if (context.mounted) context.push('/lecture/mushaf?page=$page');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          SurahListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, ref, n, startAyah: startAyah)),
          JuzListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, ref, n, startAyah: startAyah)),
          BookmarksListView(onSurahSelected: (n, {startAyah}) => _openSurah(context, ref, n, startAyah: startAyah)),
        ]),
      ),
    );
  }
}
