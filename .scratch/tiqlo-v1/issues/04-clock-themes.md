# 04: 四套 ClockTheme

**What to build:** Theme sheet 可选 Minimal、Flip、OLED、Retro，点选即时换脸。Flip 在显示数字变化时翻页。只持久化 ClockTheme id。共用 Clock 外壳，脸按 type 分发。

**Blocked by:** 02 Clock 外壳

**Status:** ready-for-agent

- [ ] 至少四套面孔可从 sheet 即时切换
- [ ] Flip 在数字变化时有翻页动画
- [ ] 重启后仍是上次选的 ClockTheme
- [ ] 换脸不改路由、不重建时间源
