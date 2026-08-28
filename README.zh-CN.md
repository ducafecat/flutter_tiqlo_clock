<p align="center">
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo Flutter 翻页时钟与极简像素界面" width="260" />
</p>

<h1 align="center">Tiqlo — Flutter 翻页时钟与专注计时器</h1>

<p align="center">
  面向手机、桌面和 Web 的极简开源 Flutter 翻页时钟、数字时钟、专注计时器与倒计时应用。
</p>

<p align="center">
  <a href="https://tiqlo.link/">Tiqlo 产品网站</a> ·
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a>
</p>

---

Tiqlo 是一款面向手机、桌面和 Web 的开源跨平台 Flutter 时钟应用。它既可作为全屏翻页时钟或数字桌面时钟，也可在需要集中注意力时启动内置 Focus 专注计时或 Timer 倒计时。
响应式的现代极简像素 UI 结合清晰的像素字体、阶梯几何、硬边描边和克制的深色配色，在横屏和竖屏中都能保持远距离可读性。

<p align="center">
  <img src="assets/images/3.0x/welcome-1.png" alt="手机上全屏显示的 Tiqlo 翻页时钟" width="30%" />
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo 数字时钟的清晰像素时间界面" width="30%" />
  <img src="assets/images/3.0x/welcome-3.png" alt="Tiqlo 全屏桌面时钟" width="30%" />
</p>

---

## Flutter 翻页时钟功能

- 两种 Clock 外观：Digital 与 Flip，可分别选择配色。
- 现代极简像素 UI：像素字体、网格对齐细节与清晰的硬边控件。
- 自适应横竖屏布局；Web 与桌面端支持全屏显示。
- 12 / 24 小时制、前导零、秒数、日期和星期显示开关。
- Night Mode：降低显示亮度，并暂时隐藏日期和秒数。
- Focus 与 Timer Session：暂停、继续、停止和完成提醒。
- Focus 完成后记录当日次数和分钟数。
- 可配置屏幕常亮、提示音与震动。
- 设置会保存在本地，下次启动自动恢复。

## 现代极简像素 UI 设计

- 为翻页数字、数码数字、界面文字和紧凑 HUD 标签分配专用像素字体，形成清晰的排版层级。
- 使用网格对齐间距、阶梯切角、清晰描边和零模糊硬阴影，不将界面栅格化也能呈现像素几何。
- 克制的深色配色与高对比时钟界面，兼顾复古感与远距离可读性。
- 使用动态 Flutter Widget 保留响应式布局、无障碍点击区、键盘焦点状态和流畅的翻页过渡。

## 运行 Flutter 时钟应用

需要 Flutter SDK（项目 Dart SDK 约束为 `^3.12.2`）。

```bash
flutter pub get
flutter run -d chrome
```

运行测试：

```bash
flutter test
```

构建 Web 发布产物：

```bash
flutter build web --release
```

将生成的整个 `build/web/` 目录部署到静态服务器。若部署在子路径，构建时需传入相应的 `--base-href`。

---

## Flutter 包列表

- 状态与路由：`flutter_riverpod`、`riverpod_annotation`、`go_router`
- 模型与本地数据：`freezed_annotation`、`json_annotation`、`shared_preferences`、`intl`、`logger`
- 提醒与设备能力：`flutter_local_notifications`、`timezone`、`wakelock_plus`、`screen_brightness`、`flutter_fullscreen`
- UI、资源与链接：`cupertino_icons`、`image`、`path`、`url_launcher`、`flutter_native_splash`
- 开发与测试：`flutter_test`、`build_runner`、`riverpod_generator`、`freezed`、`json_serializable`、`flutter_lints`、`riverpod_lint`、`icons_launcher`、`shared_preferences_platform_interface`

当前版本与完整配置请查看 [`pubspec.yaml`](pubspec.yaml)。

## Tiqlo 使用的像素字体

| 字体 | Flutter family | 字重 / 文件 | 用途 |
| --- | --- | --- | --- |
| Pixelify Sans | `PixelifySans` | 400 `PixelifySans-Regular.ttf`<br>600 `PixelifySans-SemiBold.ttf` | 界面标题、按钮、设置项与短文案 |
| Tiny5 | `Tiny5` | 400 `Tiny5-Regular.ttf` | AM/PM、FOCUS、TIMER、PAUSED 等紧凑 HUD 标签 |
| Jersey 25 | `Jersey25` | 400 `Jersey25-Regular.ttf` | 翻页时钟数字 |
| DotGothic16 | `DotGothic16` | 400 `DotGothic16-Regular.ttf` | 数字时钟数字 |

所有内置字体均采用 SIL Open Font License 1.1；上游来源、固定校验值与许可文件记录在 [`fonts/licenses`](fonts/licenses/SOURCES.md)。

## 开发 Skills

项目开发中使用了以下 skills：

- [mattpocock/skills](https://github.com/mattpocock/skills)
- [ducafecat/skills](https://github.com/ducafecat/skills)

## 设计原则

- Clock 始终显示墙上时间；Focus 和 Timer 仅在运行期间临时替换显示。
- Session 使用单调时间计算，避免设备时间变化影响倒计时。
- 横竖屏只是同一 Clock 的布局变化，不是两套页面。

更多设计决策见 [docs/adr](docs/adr)。

---

## 许可证

本项目采用 [MIT License](LICENSE)。
