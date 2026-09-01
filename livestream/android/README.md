# Safe's Playce — Livestream Android App

A small, offline Android version of the two livestream consoles:

- **Game Console** — `app/src/main/assets/game-console.html`
- **Coping Toolbox Console** — `app/src/main/assets/toolbox-console.html`

Both HTML files are bundled inside the app (in `assets/`), so the app works
with **no internet connection** while you stream. External links (helpline
sites, etc.) open in the browser; the consoles themselves never leave the app.

---

## What's in the project

```
livestream/android/
├── app/
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── assets/
│       │   ├── game-console.html
│       │   └── toolbox-console.html
│       ├── java/com/safesplayce/livestream/MainActivity.kt
│       └── res/
│           ├── layout/activity_main.xml
│           ├── mipmap-*/            # launcher icon (bee)
│           └── values/              # colors, strings, theme
├── gradle/libs.versions.toml
├── gradle/wrapper/gradle-wrapper.properties
├── gradlew                         # bootstrap wrapper (downloads jar on first run)
├── gradlew.bat
├── build.gradle.kts
├── settings.gradle.kts
└── .gitignore
```

## How to build the APK

### Option A — Android Studio (easiest)

1. Open **Android Studio** (use the latest). Choose **Open** and select the
   `livestream/android` folder.
2. If it asks, let it use the **Gradle wrapper** (Gradle 8.7).
3. **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
4. Find the APK at `app/build/outputs/apk/debug/app-debug.apk`.

### Option B — Command line (Java 17 + network for first-run wrapper download)

```bash
cd livestream/android
./gradlew assembleDebug
adb install app/build/outputs/apk/debug/app-debug.apk
```

The `gradlew` script downloads the small `gradle-wrapper.jar` on first run
(same thing Android Studio does), then downloads Gradle 8.7 once. After that
everything is cached. On Windows, use `gradlew.bat`.

### Option C — one-click script (no Android Studio)

```bash
cd livestream/android
./build.sh --no-install   # just builds the APK
./build.sh                # builds + tries to install on a connected phone via adb
```

### Option D — GitHub Actions (builds the APK for you, no local machine needed)

Pushing a commit to this repo runs **.github/workflows/android-build.yml**
automatically and uploads the APK as a downloadable artifact. This is the
easiest way to get it onto a phone without a computer handy.

## Open it on your phone

There are two ways:

1. **From a built APK file** — download/tap the `.apk`, choose **Install**,
   and (first tap only) allow *Install unknown apps* for that source. This is
   the debug-signed APK and installs fine on your own phone.
2. **From GitHub Actions (no computer needed for the build)** — in the repo,
   go to **Actions → Build Android APK → latest run**, download the
   **livestream-android-apk** artifact, unzip it, then send the
   `app-debug.apk` to your phone and tap it to install.

> The app works fully offline once installed — no TikTok or internet needed
> while you stream.

## What the app can and can't do right now

- Shows the **Game Console** on launch (spelling bee, word ladders, categories,
  phrases, word of the night, feelings bank, myth-or-fact, story chain, rhyme).
- Switch tabs to the **Coping Toolbox** (breathing pacer, guided skills,
  Sunday wind-down).
- **Offline** — no server, no network needed while streaming.
- Not yet: saving settings between app restarts, push notifications, or a
  scheduled-stream reminder. Those are natural next upgrades.

## Where to update the words/decks

Edit the two source files in `livestream/word-games/` and re-copy them into
`app/src/main/assets/`:

```bash
cp livestream/word-games/game-console.html   livestream/android/app/src/main/assets/
cp livestream/word-games/toolbox-console.html livestream/android/app/src/main/assets/
```

Then rebuild the APK. (A more polished future improvement would be one shared
assets copy — for now keeping the two copies is the simplest to build.)

## Notes on the generated look

- App name: **Safe's Playce**
- Package: `com.safesplayce.livestream`
- Min Android: **7.0 (API 23)**
- Launcher icon: a quick generated bee placeholder — replace
  `app/src/main/res/mipmap-*/ic_launcher*.png` whenever you want a branded one.
- The WebView deliberately clears all web storage on launch, so a stale copy
  of a console can never leak into the app.
