# 进后台时按剩余时间预约本地通知

Dart timer 在后台不可靠。进入 background 时按 Session remaining 预约一条本地通知；回到前台若未 Complete 则取消预约。

不依赖后台还在跑的 tick 来触发提醒。
