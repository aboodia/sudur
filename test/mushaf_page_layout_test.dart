import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/mushaf/page_layout.dart';

void main() {
  double width(double w, double h) =>
      mushafPageWidth(viewportWidth: w, viewportHeight: h);

  test('a portrait phone fills its width, the page fitting its height', () {
    // About 395 x 625 dp of reading area on a 411 x 780 phone.
    final w = width(379, 624);
    expect(w, 379);
    expect(w * mushafPageAspect, lessThanOrEqualTo(624 * 1.05));
  });

  test('a page that would overflow a short viewport is narrowed to fit', () {
    // Tall enough to need no scrolling: 700 / 1.62 = 432, below the width.
    final w = width(600, 700);
    expect(w, closeTo(700 / mushafPageAspect, 0.001));
    expect(w * mushafPageAspect, closeTo(700, 0.01));
  });

  test('a tablet in portrait shows the whole page, larger than a phone', () {
    final w = width(770, 1060);
    expect(w, lessThan(770));
    expect(w, greaterThan(379));
    expect(w * mushafPageAspect, lessThanOrEqualTo(1060));
  });

  test('landscape never stretches the page across the whole width', () {
    // 870 x 275 dp of reading area on a phone turned sideways.
    final w = width(870, 275);
    expect(w, mushafMinReadableWidth);
    expect(w, lessThan(870));
  });

  test('a landscape tablet shows the whole page when it stays readable', () {
    final w = width(1250, 650);
    expect(w, closeTo(650 / mushafPageAspect, 0.001));
    expect(w, greaterThanOrEqualTo(mushafMinReadableWidth * 0.95));
  });

  test('a viewport narrower than the readable floor is simply filled', () {
    expect(width(300, 200), 300);
  });

  test('an empty viewport gives an empty page', () {
    expect(width(0, 500), 0);
    expect(width(-5, 500), 0);
  });
}
