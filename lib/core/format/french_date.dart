import '../memorization/review_calendar.dart';

const _weekdays = [
  'lundi',
  'mardi',
  'mercredi',
  'jeudi',
  'vendredi',
  'samedi',
  'dimanche',
];

const _months = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

/// Upper-cases the first letter ("lundi 5 octobre" → "Lundi 5 octobre").
String capitalizeFirst(String s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

/// Lowercase French weekday name, Monday first (`weekday` is 1-7).
String frenchWeekday(int weekday) => _weekdays[weekday - 1];

/// First letter of the French weekday, for calendar column headers.
String frenchWeekdayInitial(int weekday) =>
    _weekdays[weekday - 1][0].toUpperCase();

/// Lowercase French month name (`month` is 1-12).
String frenchMonth(int month) => _months[month - 1];

/// "Mardi 29 septembre".
String frenchDateLabel(DateTime date) =>
    '${capitalizeFirst(frenchWeekday(date.weekday))} ${date.day} '
    '${frenchMonth(date.month)}';

/// "29 septembre 2026".
String frenchFullDate(DateTime date) =>
    '${date.day} ${frenchMonth(date.month)} ${date.year}';

/// "aujourd'hui", "demain" or "lundi 5 octobre" — [day] relative to [today].
String frenchRelativeDay(DateTime day, DateTime today) {
  final diff = daysBetween(today, day);
  if (diff == 0) return 'aujourd\'hui';
  if (diff == 1) return 'demain';
  return '${frenchWeekday(day.weekday)} ${day.day} ${frenchMonth(day.month)}';
}
