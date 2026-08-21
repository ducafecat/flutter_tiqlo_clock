# 01: 打开即墙上时间

**What to build:** 打开 App 第一眼就是 Clock：24 小时制的时、分和「星期 · 月 日」。没有 Splash、Welcome、Login。ClockEngine 用注入的 Clock 提供 now；测试用假 Clock 冻结/快进墙上时间。

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [x] 启动后第一帧是 Clock，不是欢迎页或登录页
- [x] Clock 显示当前时、分和按设备 locale 排版的日期
- [x] 面孔为 Minimal；时间来自 ClockEngine，不是 Widget 自己 tick
- [x] 假 Clock 快进后 snapshot 的墙上时间跟着变
- [x] 登录、Token、网络门闸不再挡住进入 Clock
