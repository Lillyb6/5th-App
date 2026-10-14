# StudySpace

A Flutter flashcard study app based on the Trello brainstorm.

## Available now

- Create and edit decks and cards; search the library.
- Save decks and accumulated study time on the current device.
- Tap or swipe to flip flashcards, then mark them remembered or still learning.
- Take multiple-choice quizzes that show a definition and ask you to pick the matching term from two or more options.
- Decks require at least two cards before they can be saved.
- Retry only the missed cards after either study mode.
- 25-minute Pomodoro, 50-minute focus, and 5-minute break timers.
- Export a deck as JSON to the clipboard and import pasted JSON.
- GitHub Actions checks formatting, analysis, tests, and a web build.

## Run

Install Flutter compatible with the Dart SDK constraint in pubspec.yaml.

```sh
flutter pub get
flutter run -d chrome
```

On Windows, Flutter plugins require Developer Mode for symbolic links. Enable it in Windows Settings if Flutter requests it.

```sh
flutter analyze
flutter test
flutter build web
```

## Trello items still to implement

- Server-backed accounts and secure login.
- A server database for syncing decks between devices.
- Deck membership, invitations, and shared editing.

The current persistence uses shared_preferences for a small local prototype, rather than a server database. Export/import shares separate deck copies. No login or collaboration screen pretends to be connected to a server.

Study time is counted while the study page is active, pauses when the application is backgrounded, and saves when returning to the library. Closing the process during a session can lose that session's time. Quiz mode presents a definition and asks you to choose the matching term from multiple options, with distractors drawn from the other cards in the deck.

The workflow runs when this project is pushed to GitHub; adding the file alone does not start a hosted pipeline.
