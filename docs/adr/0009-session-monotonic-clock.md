# Session 用单调时钟，Clock 用墙上时间

Clock 必须对表，所以 now 是墙上时间。Focus/Timer 要对「过了 25 分钟」，所以用单调 elapsed。改系统时间或 DST 不影响 Session。

被否决：Session 也用 DateTime deadline（用户拨表会瞬间 Complete 或倒退）。
