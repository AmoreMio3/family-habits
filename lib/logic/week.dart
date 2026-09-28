import 'dart:ui';

/// First day of the week for a locale, as a [DateTime] weekday
/// ([DateTime.monday] .. [DateTime.sunday]).
///
/// Follows CLDR week data for the regions the app ships in. The weekly
/// report and "goal met this week" both depend on it, so parents can
/// override it per family.
int firstDayOfWeek(Locale locale) {
  final region = locale.countryCode ?? _defaultRegion[locale.languageCode];
  return _sundayFirst.contains(region) ? DateTime.sunday : DateTime.monday;
}

// Regions where the week starts on Sunday, limited to the ones we ship.
const _sundayFirst = {'US', 'IL', 'BR', 'IN', 'SA', 'TW', 'MX'};

// Region to assume when a locale has only a language, e.g. `he` or `ar`.
const _defaultRegion = {
  'en': 'US',
  'es': 'ES',
  'zh': 'CN',
  'pt': 'BR',
  'fr': 'FR',
  'de': 'DE',
  'it': 'IT',
  'he': 'IL',
  'hi': 'IN',
  'ar': 'SA',
};

DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

/// Midnight on the first day of the week that contains [day].
DateTime startOfWeek(DateTime day, int firstWeekday) {
  final d = dateOnly(day);
  final back = (d.weekday - firstWeekday) % 7;
  return DateTime(d.year, d.month, d.day - back);
}

/// True when [day] falls in the week starting at [weekStart].
bool isInWeek(DateTime day, DateTime weekStart) {
  final d = dateOnly(day);
  final end = DateTime(weekStart.year, weekStart.month, weekStart.day + 7);
  return !d.isBefore(weekStart) && d.isBefore(end);
}
