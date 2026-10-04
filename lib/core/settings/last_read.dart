import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLastPage = 'reading.lastPage';

/// The Mushaf page the user was last reading, to pick up where they left
/// off; null until they have read one.
class LastReadController extends Notifier<int?> {
  @override
  int? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Storage unavailable: nothing to resume.
    }
    if (!ref.mounted) return;
    final page = prefs?.getInt(_kLastPage);
    if (page != null && page >= 1 && page <= 604) state = page;
  }

  Future<void> record(int page) async {
    if (page < 1 || page > 604 || page == state) return;
    state = page;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kLastPage, page);
    } catch (_) {
      // Not being able to remember the page is not worth interrupting for.
    }
  }
}

final lastReadProvider = NotifierProvider<LastReadController, int?>(
  LastReadController.new,
);
