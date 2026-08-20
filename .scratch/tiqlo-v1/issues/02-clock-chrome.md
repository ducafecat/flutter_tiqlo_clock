# 02: Clock 外壳

**What to build:** 同一 Clock 随横竖屏改布局（字号放大、居中、不 Overflow）。Clock 上隐藏系统栏；点屏幕出现 Theme / Focus / Timer / More，三秒无操作隐藏。More 能进 Settings 和 About 空壳。进 Settings 后系统栏恢复。

**Blocked by:** 01 打开即墙上时间

**Status:** ready-for-agent

- [ ] 横屏、竖屏都是同一 Clock，不是另一条路由
- [ ] 横屏时间更大、居中、无 Overflow
- [ ] Clock 上无状态栏/导航栏；Settings 里系统栏回来
- [ ] 点击显示操作栏，三秒无操作自动隐藏，再点可再显示
- [ ] More 可进入 Settings 与 About（内容可空，路由在）
