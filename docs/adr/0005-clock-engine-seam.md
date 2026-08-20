# 时间数学在 ClockEngine，Riverpod 只做适配

ClockEngine 注入 Clock：墙上 now 驱动显示，单调 elapsed 驱动 Session。测试打 Engine（假 Clock 可冻结/快进两种时间），不 pump 整页。墙上 now 对齐边界跳变：有秒对齐下一秒，无秒对齐下一分钟。

被否决的是 Widget 里 `Timer.periodic`，以及多个 Provider 各自算时间。
