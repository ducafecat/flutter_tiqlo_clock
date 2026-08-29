<h1 align="center">Tiqlo — Flutter Pixel Flip Clock &amp; Focus Timer</h1>

<p align="center">
  A distinctive open-source pixel-style clock with Flip, Digital, Focus, and Timer modes for mobile, desktop, and Web.
</p>

<p align="center">
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&amp;logo=flutter&amp;logoColor=white" alt="Built with Flutter" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/ducafecat/flutter_tiqlo_clock?style=flat-square" alt="MIT License" /></a>
  <a href="https://github.com/ducafecat/flutter_tiqlo_clock/stargazers"><img src="https://img.shields.io/github/stars/ducafecat/flutter_tiqlo_clock?style=flat-square&amp;logo=github" alt="GitHub stars" /></a>
  <img src="https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-ED780C?style=flat-square" alt="Platforms: Android, iOS, Web, and desktop" />
</p>

<p align="center">
  <a href="https://tiqlo.link/#demo">Live Demo</a> ·
  <a href="https://tiqlo.link/">Website</a> ·
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a>
</p>

<p align="center">
  <img src="docs/github/tiqlo-preview.png" alt="Tiqlo Pixel style (default): Flip Clock, Digital Clock, and Focus Timer" width="100%" />
  <br />
  Pixel style (default)
</p>

<p align="center">
  <img src="docs/github/tiqlo-preview-android.png" alt="Tiqlo Standard style: Flip Clock, Digital Clock, and Focus Timer" width="100%" />
  <br />
  Standard style
</p>

---

Tiqlo is an open-source Flutter clock app for mobile, desktop, and Web. What sets it apart from ordinary clock apps is a cohesive pixel-style visual system—not merely a pixel font. From the Flip and Digital clock faces to every panel, button, outline, and shadow, the entire experience is built around crisp pixel geometry.
Use it as a full-screen desk clock, or start a built-in Focus or Timer countdown when you need to concentrate. Its responsive design keeps the time clear from across a room in portrait or landscape mode.

## Try Tiqlo Online

Open the [Tiqlo live Web app](https://tiqlo.link/#demo) in your browser—no clone, account, or installation required. Tap the clock to reveal its controls.

## Pixel Clock Features

- Two UI themes: Pixel (default) and Standard. Switch them from the More menu.
- A distinctive, end-to-end pixel aesthetic across clock faces, typography, controls, panels, and transitions.
- Free, ad-free, and open source under the MIT License; no account required.
- Digital and Flip clock faces, each with its own colour palettes.
- Responsive portrait and landscape layouts; full-screen support on Web and desktop.
- 12/24-hour time, leading zero, seconds, date, and weekday options.
- Night Mode dims the display and temporarily hides the date and seconds.
- Focus and Timer sessions with pause, resume, stop, and completion alerts.
- Completed Focus sessions contribute to today's count and minutes.
- Configurable keep-awake, sound, and vibration preferences.
- Settings persist locally across launches.

## Pixel Style Is More Than a Font

- Four purpose-built pixel fonts give Flip digits, Digital digits, interface copy, and compact HUD labels their own visual character.
- Grid-aligned spacing, staircase-cut corners, crisp outlines, and zero-blur hard shadows carry the pixel language through every component—not just the clock face.
- A restrained dark palette and high-contrast clock faces keep time readable from across a room.
- Dynamic Flutter widgets preserve responsive layouts, accessible touch targets, keyboard focus states, and smooth Flip transitions without rasterising the interface.

## Run the Flutter Clock App

Flutter SDK is required. The project's Dart SDK constraint is `^3.12.2`.

```bash
flutter pub get
flutter run -d chrome
```

Run tests:

```bash
flutter test
```

Build a production Web bundle:

```bash
flutter build web --release
```

Deploy the entire generated `build/web/` directory to a static server. When serving the app from a subpath, provide the matching `--base-href` while building.

---

## Flutter Packages

- State and navigation: `flutter_riverpod`, `riverpod_annotation`, `go_router`
- Models and local data: `freezed_annotation`, `json_annotation`, `shared_preferences`, `intl`, `logger`
- Alerts and device features: `flutter_local_notifications`, `timezone`, `wakelock_plus`, `screen_brightness`, `flutter_fullscreen`
- UI, assets, and links: `cupertino_icons`, `image`, `path`, `url_launcher`, `flutter_native_splash`
- Development and testing: `flutter_test`, `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`, `flutter_lints`, `riverpod_lint`, `icons_launcher`, `shared_preferences_platform_interface`

See [`pubspec.yaml`](pubspec.yaml) for current versions and complete configuration.

## Pixel Fonts Used by Tiqlo

| Font | Flutter family | Weight / file | Usage |
| --- | --- | --- | --- |
| Pixelify Sans | `PixelifySans` | 400 `PixelifySans-Regular.ttf`<br>600 `PixelifySans-SemiBold.ttf` | Interface headings, buttons, settings, and short copy |
| Tiny5 | `Tiny5` | 400 `Tiny5-Regular.ttf` | Compact HUD labels such as AM/PM, FOCUS, TIMER, and PAUSED |
| Jersey 25 | `Jersey25` | 400 `Jersey25-Regular.ttf` | Flip clock digits |
| DotGothic16 | `DotGothic16` | 400 `DotGothic16-Regular.ttf` | Digital clock digits |

All bundled fonts use the SIL Open Font License 1.1. Their upstream sources, fixed checksums, and license files are recorded in [`fonts/licenses`](fonts/licenses/SOURCES.md).

## Development Skills

This project uses development skills from:

- [mattpocock/skills](https://github.com/mattpocock/skills)
- [ducafecat/skills](https://github.com/ducafecat/skills)

## Principles

- Clock always represents wall-clock time; Focus and Timer temporarily replace the display only while active.
- Sessions use monotonic time, so device clock changes do not affect countdowns.
- Portrait and landscape are layouts of one Clock, not separate pages.

See [docs/adr](docs/adr) for design decisions.

---

## License

Licensed under the [MIT License](LICENSE).
