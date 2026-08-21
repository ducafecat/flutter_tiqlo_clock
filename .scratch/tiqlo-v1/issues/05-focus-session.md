# 05: Focus Session

**What to build:** 从 Clock 打开 Focus 选择：15/25/45/60 与 Custom（1–90 分钟，步进 1）。突出 25。Start 后 Clock 显示剩余 `mm:ss` 和 FOCUS。运行中操作栏只有 Pause / Stop。Pause 冻 remaining，Resume 仍是同一次。Stop 回到墙上时间且不记账。剩余用单调 elapsed。同时只能有一个 Session。杀进程后同一次开机按 elapsed 恢复。

**Blocked by:** 01 打开即墙上时间；02 Clock 外壳

**Status:** ready-for-agent

- [x] 可选预设与 Custom，25 分钟被突出
- [x] 运行中显示 `mm:ss` + FOCUS，与「显示秒」设置无关
- [x] Pause / Resume 为同一次 Session；Stop 回墙上时间
- [x] 运行中不能开第二个 Session，也不能进 Theme / Night / Settings
- [x] 假 Clock 只快进单调时间时 remaining 减少，快进墙上 now 不影响 remaining
- [x] 同开机模拟重载后未结束的 Session 按已流逝时间恢复
