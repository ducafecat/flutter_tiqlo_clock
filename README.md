<p align="center">
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo Flutter flip clock with a minimal pixel UI" width="260" />
</p>

<h1 align="center">Tiqlo — Flutter Flip Clock &amp; Focus Timer</h1>

<p align="center">
  A minimal open-source Flutter flip clock, digital clock, focus timer, and countdown app for mobile, desktop, and web.
</p>

<p align="center">
  <a href="https://tiqlo.link/">Tiqlo Website</a> ·
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a>
</p>

---

Tiqlo is an open-source Flutter clock app for mobile, desktop, and Web. Use it as a full-screen flip clock or digital desk clock, or start a built-in Focus or Timer countdown when you need to concentrate.
Its responsive Minimal Pixel UI combines crisp pixel typography, stepped geometry, hard-edged outlines, and a restrained dark palette, keeping the time clear from across a room in portrait or landscape mode.

<p align="center">
  <img src="assets/images/3.0x/welcome-1.png" alt="Full-screen Tiqlo flip clock on a phone" width="30%" />
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo digital clock with a clear pixel time display" width="30%" />
  <img src="assets/images/3.0x/welcome-3.png" alt="Tiqlo full-screen desktop clock" width="30%" />
</p>

---

## Flutter Flip Clock Features

- Digital and Flip clock faces, each with its own colour palettes.
- Minimal Pixel UI with pixel typography, grid-aligned details, and crisp hard-edged controls.
- Responsive portrait and landscape layouts; full-screen support on Web and desktop.
- 12/24-hour time, leading zero, seconds, date, and weekday options.
- Night Mode dims the display and temporarily hides the date and seconds.
- Focus and Timer sessions with pause, resume, stop, and completion alerts.
- Completed Focus sessions contribute to today's count and minutes.
- Configurable keep-awake, sound, and vibration preferences.
- Settings persist locally across launches.

## Minimal Pixel UI Design

- Purpose-built typography assigns a dedicated pixel font to Flip digits, Digital digits, interface copy, and compact HUD labels.
- Grid-aligned spacing, staircase-cut corners, crisp outlines, and zero-blur hard shadows create the pixel geometry without rasterising the interface.
- A restrained dark palette and high-contrast clock faces keep time readable from across a room.
- Dynamic Flutter widgets preserve responsive layouts, accessible touch targets, keyboard focus states, and smooth Flip transitions across screen sizes.

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
