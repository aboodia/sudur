import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';
import 'profile_repository.dart';

class BookmarkRepository {
  BookmarkRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<Bookmark>> watchAll(String profileId) {
    return (_db.select(_db.bookmarks)
          ..where((b) => b.profileId.equals(profileId))
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
  }

  Future<bool> isBookmarked(String profileId, int surahNumber, int ayahNumber) async {
    final row = await (_db.select(_db.bookmarks)
          ..where((b) =>
              b.profileId.equals(profileId) &
              b.surahNumber.equals(surahNumber) &
              b.ayahNumber.equals(ayahNumber)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> toggle(String profileId, int surahNumber, int ayahNumber) async {
    final existing = await (_db.select(_db.bookmarks)
          ..where((b) =>
              b.profileId.equals(profileId) &
              b.surahNumber.equals(surahNumber) &
              b.ayahNumber.equals(ayahNumber)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.delete(_db.bookmarks)..where((b) => b.id.equals(existing.id))).go();
      return;
    }

    await _db.into(_db.bookmarks).insert(
          BookmarksCompanion.insert(
            id: _uuid.v4(),
            profileId: profileId,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            createdAt: DateTime.now(),
          ),
        );
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(ref.watch(appDatabaseProvider));
});

final bookmarksProvider = StreamProvider<List<Bookmark>>((ref) async* {
  final profile = await ref.watch(currentProfileProvider.future);
  yield* ref.watch(bookmarkRepositoryProvider).watchAll(profile.id);
});
