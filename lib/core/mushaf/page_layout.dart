import 'dart:math' as math;

/// Height of a full 15-line Mushaf page for each unit of its width, as the
/// lines come out when every line is stretched to the page's width
/// (measured on the QCF v4 pages with the app's line spacing).
const mushafPageAspect = 1.62;

/// The narrowest page still comfortable to read — the width of a page on a
/// portrait phone. Below this, a page is allowed to scroll rather than
/// shrink.
const mushafMinReadableWidth = 380.0;

/// The width, in logical pixels, at which a Mushaf page is laid out inside a
/// viewport of [viewportWidth] x [viewportHeight].
///
/// In landscape the page takes the whole width, whatever the screen: the
/// text grows with it and the page scrolls vertically.
///
/// In portrait a page is as wide as the screen allows, but no wider than
/// what lets the whole page fit in the height: on a tablet, or a short
/// phone, the page is shown whole instead of scrolling — without going
/// narrower than [mushafMinReadableWidth].
double mushafPageWidth({
  required double viewportWidth,
  required double viewportHeight,
}) {
  if (viewportWidth <= 0) return 0;
  if (viewportWidth > viewportHeight) return viewportWidth;
  final fitsHeight = viewportHeight / mushafPageAspect;
  final readableFloor = math.min(viewportWidth, mushafMinReadableWidth);
  return math.min(viewportWidth, math.max(fitsHeight, readableFloor));
}
