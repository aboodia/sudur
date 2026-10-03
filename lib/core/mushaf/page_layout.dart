import 'dart:math' as math;

/// Height of a full 15-line Mushaf page for each unit of its width, as the
/// lines come out when every line is stretched to the page's width
/// (measured on the QCF v4 pages with the app's line spacing).
const mushafPageAspect = 1.62;

/// The narrowest page still comfortable to read — the width of a page on a
/// portrait phone, so the text keeps that size when the phone is turned.
/// Below this, a page is
/// allowed to scroll rather than shrink.
const mushafMinReadableWidth = 380.0;

/// The width, in logical pixels, at which a Mushaf page is laid out inside a
/// viewport of [viewportWidth] x [viewportHeight].
///
/// A page is as wide as the screen allows, but no wider than what lets the
/// whole page fit in the height: on a tablet, or a short portrait phone, the
/// page is shown whole instead of scrolling. In landscape that would shrink
/// the text to nothing, so the page stops at [mushafMinReadableWidth]
/// (centered, scrolling vertically) instead of stretching across the whole
/// width into giant lines.
double mushafPageWidth({
  required double viewportWidth,
  required double viewportHeight,
}) {
  if (viewportWidth <= 0) return 0;
  final fitsHeight = viewportHeight / mushafPageAspect;
  final readableFloor = math.min(viewportWidth, mushafMinReadableWidth);
  return math.min(viewportWidth, math.max(fitsHeight, readableFloor));
}
