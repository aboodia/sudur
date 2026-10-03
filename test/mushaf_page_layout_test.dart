import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/mushaf/page_layout.dart';

void main() {
  double width(double w, double h) =>
      mushafPageWidth(viewportWidth: w, viewportHeight: h);

  test('a portrait phone fills its width, the page fitting its height', () {
    // About 379 x 624 dp of reading area on a 411 x 780 phone.
    final w = width(379, 624);
    expect(w, 379);
    expect(w * mushafPageAspect, lessThanOrEqualTo(624 * 1.05));
  });

  test('a page that would overflow a short portrait viewport is narrowed', () {
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

  test('the page never gets narrower than readable in portrait', () {
    expect(width(400, 450), mushafMinReadableWidth);
    expect(width(380, 500), 380);
  });

  test('landscape takes the whole width, whatever the screen', () {
    // A phone turned sideways, then a tablet.
    expect(width(870, 275), 870);
    expect(width(1250, 650), 1250);
  });

  test('a viewport narrower than the readable floor is simply filled', () {
    expect(width(300, 500), 300);
  });

  test('an empty viewport gives an empty page', () {
    expect(width(0, 500), 0);
    expect(width(-5, 500), 0);
  });
}
