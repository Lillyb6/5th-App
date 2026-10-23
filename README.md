# StudySpace

A Flutter flashcard study app based on the Trello brainstorm.

## Available now

- A navy and indigo dark theme by default, with bundled Manrope typography.
- A Study Space home page with saved deck, study-minute, and completed-flashcard stats, plus shortcuts to the library, studying, and deck creation.
- Three aligned timer choices with a highlighted selection and a separate Begin studying action.

- Create and edit decks and cards; search the library.
- Save decks and accumulated study time on the current device.
- Tap to flip flashcards; swipe right for Got it or left for Still learning, or use the buttons.
- Take multiple-choice quizzes that show a definition and ask you to pick the matching term from two or more options.
- Decks require at least two cards before they can be saved.
- Retry only the missed cards after either study mode.
- Choose Pomodoro with an adjustable countdown, an open-ended count-up timer, or Flowtime / Flowmodoro with breaks lasting one-fifth of the focus time.
- Export a deck as JSON to the clipboard and import pasted JSON.
- Enter as a guest, use the local demo account, or configure Supabase for hosted email accounts and per-account deck sync.
- Choose English, Spanish, Vietnamese, Chinese, Japanese, Dutch, or German for the app interface.
- Switch between light and dark themes; language and theme preferences are saved on the device.
- GitHub Actions checks formatting, analysis, tests, and a web build.

## Run

Install Flutter compatible with the Dart SDK constraint in `pubspec.yaml` (Dart 3.13.1 or later, below 4.0.0). Run these commands from the project folder.

```sh
flutter pub get
flutter run -d chrome
```

On Windows, Flutter plugins require Developer Mode for symbolic links. Enable it in Windows Settings if Flutter requests it.

### Run on Android

Install Android Studio and the Android SDK, then start an emulator in Device Manager or connect an Android phone with USB debugging enabled.

```sh
flutter doctor
flutter devices
flutter pub get
flutter run -d <device-id>
```

Replace `<device-id>` with the Android device ID listed by `flutter devices` (for example, `emulator-5554`). In Android Studio, open this project folder, select the Android device, and run `lib/main.dart`.

To download the newest code before running, commit or stash any local changes first, then run:

```sh
git pull --ff-only origin main
flutter pub get
```

### Check and build locally


```sh
flutter analyze
flutter test
flutter build web
```

## Supabase setup

The app uses the Flutter Supabase client, not the JavaScript `@supabase/server` package. It initializes Supabase with this project's URL and publishable key by default. You can override them with `--dart-define`; sign-up and sign-in use Supabase Auth, and signed-in users' decks sync through `user_deck_data`.

The default project is `dylpsslfmrrnskboisia` (hollylester's Project). Accounts from the previous project are separate; create a new demo account in this project. Restart or rebuild the app after changing the project connection. Explicit `--dart-define` values override these defaults.

1. Apply both database migrations to your Supabase project in timestamp order. Run [20261020160000_user_deck_data.sql](./supabase/migrations/20261020160000_user_deck_data.sql), then [20261020170000_seed_user_decks.sql](./supabase/migrations/20261020170000_seed_user_decks.sql), in Supabase **SQL Editor**. The second migration seeds starter decks for existing accounts and automatically adds one for new accounts. Alternatively, with the Supabase CLI:

   ```sh
   supabase init
   supabase link --project-ref YOUR_PROJECT_REF
   supabase db push
   ```

   The migration enables row-level security so users can only read and change their own deck row. Make sure Email authentication is enabled in Supabase Auth settings.

2. Optionally override the default project URL and **publishable** key from Supabase project API settings when starting the app:

   ```sh
   flutter run -d chrome \
     --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
     --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_SUPABASE_PUBLISHABLE_KEY
   ```

   Use the same `--dart-define` options for `flutter build web`. Do not put the Supabase secret/service-role key in Flutter, a `.env` shipped with the app, or Git. Only the publishable key belongs in a client app; RLS is what protects user data.

Local guest and prototype-account flows remain available. Local accounts and existing guest decks are not automatically migrated to a Supabase account.

## Trello items still to implement

- Deck membership, invitations, and shared editing.
- Public deck discovery and moderation.

Local prototype accounts and their deck data are stored on the device with shared_preferences and do not sync between devices. Passwords in that local-only mode are stored as salted SHA-256 hashes; this is not production authentication or secure credential storage. Do not use real or reused passwords. Guest access continues to use the device's existing local library. Export/import shares separate deck copies.

Supabase email sign-up may require confirming the email before signing in. Set the Supabase Auth **Site URL** and allowed redirect URLs to the app's development or deployed web address. Local guest decks and prototype-account data are not automatically migrated to a Supabase account.

The app interface is available in English, Spanish, Vietnamese, Chinese, Japanese, Dutch, and German. User-created deck titles and card content are not automatically translated.

Study time is counted while the study page is active, pauses when the application is backgrounded, and saves when returning to the library. Closing the process during a session can lose that session's time. Quiz mode presents a definition and asks you to choose the matching term from multiple options, with distractors drawn from the other cards in the deck.

The workflow runs when this project is pushed to GitHub; adding the file alone does not start a hosted pipeline.
