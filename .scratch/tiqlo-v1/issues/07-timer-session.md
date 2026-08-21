# 07: Timer

**What to build:** Timer 是同一种 Session，`kind: timer`。预设 1/5/10/30 与 Custom（1–180 分钟）。运行中标 TIMER，Pause/Stop 与 Focus 相同。Complete 同样提醒，不记入今日 Focus 统计。

**Blocked by:** 05 Focus Session；06 Focus Complete 与今日统计

**Status:** resolved

- [x] 可从 Clock 开始 Timer，显示 `mm:ss` + TIMER
- [x] Pause / Resume / Stop 行为与 Focus 相同
- [x] Timer Complete 有提醒，今日 Focus 次数和分钟不变
- [x] Focus 跑着时不能开 Timer，反之亦然

## Answer

Clock 上 Timer sheet：预设 1/5/10/30、Custom 1–180。`start(SessionKind.timer)` 走同一套 Session；运行中标 TIMER；Pause/Stop 与 Focus 相同；Complete 提醒不记今日 Focus。同时只能有一个 Session。
