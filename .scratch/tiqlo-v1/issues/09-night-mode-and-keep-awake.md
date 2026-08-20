# 09: Night Mode 与 Keep Awake

**What to build:** Night Mode 手动开关，叠在当前 ClockTheme 上：字改暗、隐藏日期和秒、暂时降低系统亮度，退出后恢复。Keep Screen Awake 默认开，Clock（含 Session）页常亮，进 Settings 恢复系统熄屏策略，设置里可关掉常亮。

**Blocked by:** 02 Clock 外壳；03 时间显示设置

**Status:** ready-for-agent

- [ ] Night Mode 不切换 ClockTheme
- [ ] 开启后字更暗、无日期无秒、系统亮度下降；关闭后亮度恢复
- [ ] Night Mode 选择能记住
- [ ] Clock/Session 默认常亮；Settings 页不强制常亮
- [ ] 可在 Settings 关闭 Keep Screen Awake
