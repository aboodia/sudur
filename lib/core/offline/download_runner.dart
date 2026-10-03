/// How a batch of downloads is going.
class DownloadProgress {
  const DownloadProgress({
    required this.total,
    required this.done,
    required this.failed,
  });

  final int total;

  /// Items fetched (or already there).
  final int done;

  /// Items that could not be fetched.
  final int failed;

  int get finished => done + failed;
  bool get complete => finished >= total;
  double get fraction => total == 0 ? 1 : finished / total;
}

/// Runs [download] on every item, [concurrency] at a time, reporting after
/// each one. [isCancelled] is checked before each item starts: items not
/// started yet are then left alone, and the ones in flight finish. An item
/// whose download throws counts as failed rather than stopping the batch.
Future<DownloadProgress> runDownloads<T>(
  List<T> items,
  Future<bool> Function(T item) download, {
  int concurrency = 3,
  void Function(DownloadProgress progress)? onProgress,
  bool Function()? isCancelled,
}) async {
  var next = 0;
  var done = 0;
  var failed = 0;

  DownloadProgress snapshot() =>
      DownloadProgress(total: items.length, done: done, failed: failed);

  Future<void> worker() async {
    while (true) {
      if (isCancelled?.call() ?? false) return;
      if (next >= items.length) return;
      final item = items[next++];
      bool ok;
      try {
        ok = await download(item);
      } catch (_) {
        ok = false;
      }
      if (ok) {
        done++;
      } else {
        failed++;
      }
      onProgress?.call(snapshot());
    }
  }

  final workers = concurrency < 1 ? 1 : concurrency;
  await Future.wait([for (var i = 0; i < workers; i++) worker()]);
  return snapshot();
}
