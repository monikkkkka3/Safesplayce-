# Agent Instructions

## Repository Overview

Safe's Playce is an offline livestream toolkit for word games and peer-support activities.

- `livestream/word-games/` contains the source HTML consoles and game data.
- `livestream/android/` contains the Android WebView wrapper and bundled console assets.
- `livestream/*.md` contains programming, safety, moderation, growth, and measurement guidance.
- `book/` contains separate story-planning material.

## Working Rules

- Keep changes focused on the requested behavior; do not rewrite unrelated prose or generated assets.
- Preserve offline operation. Do not add network dependencies to the consoles or Android app unless explicitly requested.
- Treat the HTML files in `livestream/word-games/` as the source of truth. When changing a console, copy the updated file into `livestream/android/app/src/main/assets/` so the APK matches the browser version.
- Keep the Android package and WebView entry points compatible with the existing structure unless a platform change is required.
- Do not present the project as therapy or professional mental-health care. Preserve crisis-resource links, peer-support boundaries, and moderation safeguards when editing related content.
- Prefer plain ASCII in source and documentation unless the surrounding content already requires other characters.
- Do not commit changes, alter branches, or remove user work.

## Validation

For console changes:

- Open the changed HTML directly in a browser and exercise the affected controls.
- Check that random/deck behavior, keyboard controls, and offline loading still work when relevant.

For Android changes:

```bash
cd livestream/android
./build.sh --no-install
```

Use `./gradlew test` or `./gradlew lint` when the change affects code paths covered by those checks. Java 17 is required for the Android build. Do not require a connected device for validation.

For source console updates, synchronize the bundled assets before building:

```bash
cp livestream/word-games/game-console.html livestream/android/app/src/main/assets/
cp livestream/word-games/toolbox-console.html livestream/android/app/src/main/assets/
```

## Editing Guidance

- Match the existing HTML, CSS, Kotlin, and Markdown style.
- Favor small, readable changes over new abstractions.
- Keep UI controls usable on a phone and while streaming: large targets, clear state, and no dependence on an internet connection.
- Update nearby documentation when a command, file location, or user-visible workflow changes.