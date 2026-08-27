<p align="center">
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo 翻页时钟" width="260" />
</p>

<h1 align="center">Tiqlo</h1>

<p align="center">
  清晰看见时间的全屏时钟。
</p>

<p align="center">
  <a href="https://tiqlo.link/">产品网站</a> ·
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">简体中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a>
</p>

---

一个全屏时钟，提供数字时钟与翻页时钟两种外观，并内置 Focus 与 Timer 倒计时。
采用现代极简像素 UI，以清晰的像素字体、阶梯几何、硬边描边和克制的深色配色，营造复古个性，同时确保远距离查看时间依然清晰。

<p align="center">
  <img src="assets/images/3.0x/welcome-1.png" alt="Tiqlo 手机翻页时钟" width="30%" />
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo 清晰显示时间" width="30%" />
  <img src="assets/images/3.0x/welcome-3.png" alt="Tiqlo 桌面时钟" width="30%" />
</p>

---

## 功能

- 两种 Clock 外观：Digital 与 Flip，可分别选择配色。
- 现代极简像素 UI：像素字体、网格对齐细节与清晰的硬边控件。
- 自适应横竖屏布局；Web 与桌面端支持全屏显示。
- 12 / 24 小时制、前导零、秒数、日期和星期显示开关。
- Night Mode：降低显示亮度，并暂时隐藏日期和秒数。
- Focus 与 Timer Session：暂停、继续、停止和完成提醒。
- Focus 完成后记录当日次数和分钟数。
- 可配置屏幕常亮、提示音与震动。
- 设置会保存在本地，下次启动自动恢复。

## 开发

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

## 技术栈

- Flutter / Dart
- Riverpod
- go_router
- shared_preferences
- intl

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
