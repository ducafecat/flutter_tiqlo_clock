# 08: 后台通知与重启 Pause

**What to build:** Session 进后台不暂停，按 remaining 预约本地通知；回前台未 Complete 则取消预约。第一次 Start 才申请通知权限；拒绝后 Session 仍可跑，回前台再 Complete。设备重启后未完成 Session 视为 Pause。

**Blocked by:** 06 Focus Complete 与今日统计

**Status:** ready-for-agent

- [ ] 进入后台时按剩余时间预约一条本地通知
- [ ] 回到前台且尚未 Complete 时取消该通知
- [ ] 第一次 Start 才出现权限询问，启动进 Clock 时不询问
- [ ] 拒绝权限后仍能 Start；无后台通知，回前台可进 Complete
- [ ] 重启后未完成 Session 处于 Pause，remaining 冻结
