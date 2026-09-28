# Family Habits

A habit tracker for the whole family. Parents track their own habits, manage
supervised child profiles, and share family habits with one progress bar
everyone can see. Android first, iPhone later, built with Flutter.

## What works today

- Today screen with a profile switcher (several family members on one device)
- Family progress bar for the week, split by member, filling in reading direction
- Family habits that a parent checks in once for the whole family
- Personal habits with weekly targets and streaks
- 16 built-in categories with subcategories
- 13 locales: `en-US`, `en-GB`, `es-ES`, `es-419`, `zh-CN`, `zh-TW`, `pt-BR`,
  `fr-FR`, `de-DE`, `it-IT`, `he-IL`, `hi-IN`, `ar-SA`, with right-to-left
  layout for Hebrew and Arabic
- Week start follows the locale (Sunday in Israel and the US, Monday in most of Europe)

Data is an in-memory sample family for now. Accounts, sync and push
notifications come next.

## Run it

```sh
flutter pub get
flutter run
```

Use the translate icon in the app bar to switch language.

## Checks

```sh
dart format lib test
flutter analyze
flutter test
```

## Translations

Strings live in `lib/l10n/app_<locale>.arb`, with `app_en.arb` as the source.
Translations other than English are first drafts and need review by a native
speaker. Subcategory names are English seed values for now.

## Layout

```
lib/
  app.dart              MaterialApp, locales, theme
  models/               categories, members, habits, check-ins
  logic/                week start, weekly goals, family progress, streaks
  data/                 in-memory family store and sample family
  ui/                   screens and widgets
  l10n/                 translation files
```
