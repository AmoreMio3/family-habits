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
- Week start follows the locale (Sunday in Israel and the US, Monday in most of Europe),
  and a parent can change it for the family
- Parent accounts with email and password, and a second parent joins with an invite code
- Child profiles created by a parent (nickname and age range, no email), with
  recorded parent consent and an optional PIN for shared devices
- A child's own phone or tablet joins with a one-time code and sees only that child
- Parents add, edit and delete habits and family members
- Everything syncs between the family's devices through Firebase
- Delete account inside the app (required by Google Play)

Daily and weekly summary notifications come next.

## Two modes

Until the app is connected to a Firebase project, it runs in demo mode: the
welcome screen offers "Try the demo family", and sign-up works but is kept in
memory only. Once `lib/firebase_options.dart` is generated (below), the app uses
Firebase for sign-in and storage.

## Connect Firebase

One time, on the free Spark plan:

1. At https://console.firebase.google.com, create a project (Google Analytics can be off).
2. Build > Authentication > Get started, then enable **Email/Password** and **Anonymous**.
   Anonymous sign-in is how a child's device joins with a code.
3. Build > Firestore Database > Create database, in production mode, in a region near you.
4. On your computer, install the Firebase CLI and FlutterFire CLI, then run in this folder:

   ```sh
   firebase login
   dart pub global activate flutterfire_cli
   flutterfire configure            # pick the project, tick android and ios
   firebase use --add               # pick the same project
   firebase deploy --only firestore:rules
   ```

`flutterfire configure` replaces `lib/firebase_options.dart` and adds
`android/app/google-services.json`. Both are safe to commit; access is
controlled by `firestore.rules`.

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
cd firebase && npm ci && npm test   # security rules, needs Java 21
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
  data/                 accounts, Firestore and in-memory storage, family store
  ui/                   screens and widgets
  l10n/                 translation files
firestore.rules         who can read and write what
firebase/               security rules tests (Firestore emulator)
```
