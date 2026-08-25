<p align="center">
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo 翻頁時鐘" width="260" />
</p>

<h1 align="center">Tiqlo</h1>

<p align="center">
  清楚看見時間的全螢幕時鐘。
</p>

<p align="center">
  <a href="https://tiqlo.link/">產品網站</a> ·
  <a href="README.md">English</a> ·
  <a href="README.zh-CN.md">簡體中文</a> ·
  <a href="README.zh-TW.md">繁體中文</a>
</p>

---

一個全螢幕時鐘，提供數位時鐘與翻頁時鐘兩種外觀，並內建 Focus 與 Timer 倒數計時。

<p align="center">
  <img src="assets/images/3.0x/welcome-1.png" alt="Tiqlo 手機翻頁時鐘" width="30%" />
  <img src="assets/images/3.0x/welcome-2.png" alt="Tiqlo 清楚顯示時間" width="30%" />
  <img src="assets/images/3.0x/welcome-3.png" alt="Tiqlo 桌面時鐘" width="30%" />
</p>

---

## 功能

- 兩種 Clock 外觀：Digital 與 Flip，可分別選擇配色。
- 自適應橫豎螢幕版面；Web 與桌面端支援全螢幕顯示。
- 12 / 24 小時制、前導零、秒數、日期和星期顯示開關。
- Night Mode：降低顯示亮度，並暫時隱藏日期和秒數。
- Focus 與 Timer Session：暫停、繼續、停止和完成提醒。
- Focus 完成後記錄當日次數和分鐘數。
- 可設定螢幕常亮、提示音與震動。
- 設定會儲存在本機，下次啟動時自動恢復。

## 開發

需要 Flutter SDK（專案 Dart SDK 約束為 `^3.12.2`）。

```bash
flutter pub get
flutter run -d chrome
```

執行測試：

```bash
flutter test
```

建立 Web 發布產物：

```bash
flutter build web --release
```

將產生的完整 `build/web/` 目錄部署至靜態伺服器。若將應用程式部署在子路徑，建置時請傳入對應的 `--base-href`。

---

## 技術棧

- Flutter / Dart
- Riverpod
- go_router
- shared_preferences
- intl

## 設計原則

- Clock 一律顯示牆上時間；Focus 和 Timer 僅在執行期間暫時取代顯示內容。
- Session 使用單調時間計算，避免裝置時間變動影響倒數計時。
- 橫豎螢幕只是同一個 Clock 的版面變化，並非兩套頁面。

更多設計決策請見 [docs/adr](docs/adr)。

---

## 授權條款

本專案採用 [MIT License](LICENSE)。
