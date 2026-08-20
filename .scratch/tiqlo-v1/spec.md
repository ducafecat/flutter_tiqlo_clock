# Tiqlo V1.0

Status: ready-for-agent

## Problem Statement

用户想把手机变成一台漂亮、沉浸、适合专注的桌面时钟。打开就要看到时间，横放桌上能用一小时以上。现有脚手架却是 Splash → Welcome → Login，还有网络和登录，和这个目标相反。

## Solution

打开即 Clock。墙上时间始终在。Focus 和 Timer 是 Clock 上的 Session，倒计时结束再回到墙上时间。四套 ClockTheme 可换。Night Mode 把床头光线压下去。全部本地，重启不丢设置。

## User Stories

1. As a 用户, I want 打开 App 立刻看到 Clock, so that 不经过欢迎页或登录
2. As a 用户, I want Clock 上大部分时间只有时间, so that 像一台时钟而不是工具 App
3. As a 用户, I want 看到当前时和分, so that 知道现在几点
4. As a 用户, I want 看到星期和日期, so that 不用再看日历
5. As a 用户, I want 日期按设备语言显示且版式为「星期 · 月 日」, so that 中文设备看到「周四 · 8月20日」而不是被锁成英文
6. As a 用户, I want 12 小时制时看到 AM/PM, so that 不会把 9 点当成 21 点
7. As a 用户, I want 24 小时制时不看到 AM/PM, so that 界面更干净
8. As a 用户, I want 默认跟随设备的 12/24 小时制并允许改掉后记住, so that 不用每次重设
9. As a 用户, I want 可选显示秒, so that 需要精确时能看到秒
10. As a 用户, I want 关闭秒时 Clock 不要每秒闪, so that 桌上长时间显示更省电、更稳
11. As a 用户, I want 横放手机时时间自动变大并居中, so that 当桌面钟用
12. As a 用户, I want 竖拿时也能看时间且不 Overflow, so that 偶尔拿起来仍然可用
13. As a 用户, I want 横竖切换不要像进了另一个 App, so that 方向只是布局
14. As a 用户, I want Clock 上没有状态栏和导航栏, so that 全屏沉浸
15. As a 用户, I want 进入 Settings 后系统栏回来, so that 能用系统返回和看时间以外的设置
16. As a 用户, I want 点击屏幕出现 Theme / Focus / Timer / More, so that 需要时才有操作
17. As a 用户, I want 三秒无操作后操作栏自动隐藏, so that 屏幕回到只有时间
18. As a 用户, I want 再点一次重新显示操作栏, so that 随时能操作
19. As a 用户, I want 至少四套 ClockTheme（Minimal、Flip、OLED、Retro）, so that 能选喜欢的面孔
20. As a 用户, I want 点 Theme 从底部选出面孔并即时预览, so that 不用重启就能看效果
21. As a 用户, I want Flip 在数字变化时有翻页动画, so that 像经典翻页钟
22. As a 用户, I want 选中的 ClockTheme 下次打开还在, so that 不用每天重选
23. As a 用户, I want Night Mode 叠在当前 ClockTheme 上而不是换成另一套面孔, so that 床头也能用 Flip 或 Retro
24. As a 用户, I want Night Mode 把字变暗、藏日期和秒, so that 信息更少
25. As a 用户, I want Night Mode 暂时降低系统亮度并在退出后恢复, so that OLED 床头不会太亮
26. As a 用户, I want Night Mode 只有手动开关, so that 不会在下午被自动弄暗
27. As a 用户, I want Keep Screen Awake 默认开着, so that 放桌上不会熄屏
28. As a 用户, I want 进 Settings 后恢复系统熄屏策略, so that 离开 Clock 不再强行常亮
29. As a 用户, I want 能关掉 Keep Screen Awake, so that 在乎电量时可以睡屏
30. As a 用户, I want 点 Focus 看到 15/25/45/60 分钟和 Custom, so that 快速开始专注
31. As a 用户, I want 25 分钟被突出, so that 默认选择最常见的一段
32. As a 用户, I want Custom Focus 在 1–90 分钟、步进 1 分钟, so that 预设不够时仍能设
33. As a 用户, I want 开始 Focus 后 Clock 变成剩余 `mm:ss` 并标着 FOCUS, so that 知道自己在专注
34. As a 用户, I want Focus 跑着时点屏幕只出现 Pause 和 Stop, so that 不会误开 Timer 或跑去设置
35. As a 用户, I want Pause 后剩余时间冻结, so that 接电话不会把这段 Focus 作废
36. As a 用户, I want Resume 后从冻结的剩余继续, so that 仍是同一次 Focus
37. As a 用户, I want Stop 后回到墙上时间且今日统计不加, so that 放弃的专注不算完成
38. As a 用户, I want Focus 到 0 时看到 Complete、听到提示音、震动一次, so that 知道这段结束了
39. As a 用户, I want Complete 上点 Done 后回到墙上时间, so that 主动确认结束
40. As a 用户, I want 只有 Complete 的 Focus 记入今日次数和分钟, so that 统计可信
41. As a 用户, I want 在 Focus 选择 sheet 底部看到 Today 的次数和分钟, so that 开始前知道今天做了多少
42. As a 用户, I want Complete 画面只展示本次而不是堆今日总览, so that 结束时足够安静
43. As a 用户, I want 今日统计在本地 0:00 分界, so that 跨夜不会把昨天算进来
44. As a 用户, I want 改系统时间或 DST 时 Focus 仍按真实流逝的 25 分钟走, so that 拨表不能作弊或瞬间结束
45. As a 用户, I want 点 Timer 看到 1/5/10/30 分钟和 Custom, so that 普通倒计时和 Focus 分开
46. As a 用户, I want Custom Timer 在 1–180 分钟、步进 1 分钟, so that 煮东西也可以
47. As a 用户, I want Timer 跑着时显示剩余 `mm:ss` 并标着 TIMER, so that 不会当成 Focus
48. As a 用户, I want Timer 同样能 Pause / Resume / Stop, so that 操作一致
49. As a 用户, I want Timer Complete 有声音和震动但不记 Focus 统计, so that 倒计时不是专注记录
50. As a 用户, I want 同一时间只能有一个 Session, so that 不会 Focus 和 Timer 抢屏幕
51. As a 用户, I want 切到其他 App 时 Session 继续走, so that 接电话不会被悄悄暂停
52. As a 用户, I want 后台走完时收到本地通知, so that 人没看着 Clock 也知道结束了
53. As a 用户, I want 点通知或回到 App 看到 Complete, so that 能确认结束
54. As a 用户, I want 第一次 Start 才被问通知权限, so that 打开 App 第一眼仍是 Clock
55. As a 用户, I want 拒绝通知权限后 Session 仍然能跑, so that 权限不是门槛；回到前台再看 Complete
56. As a 用户, I want 系统杀掉 App 后再打开，未完成的 Session 按已经过去的时间接着走或直接 Complete, so that 杀进程不能赖掉 Focus
57. As a 用户, I want 设备重启后未完成的 Session 处于 Pause, so that 重启不等于完成
58. As a 用户, I want More 里进入 Night Mode、Settings、About, so that 次要入口不占 Clock
59. As a 用户, I want Settings 里改时间制、秒、常亮、声音、震动、默认 ClockTheme、Night Mode, so that 能管所有本地偏好
60. As a 用户, I want 关掉声音或震动后 Complete 不再响或震, so that 图书馆也能用
61. As a 用户, I want 重启 App 后设置还在, so that 不用每次重配
62. As a 用户, I want About 里看到版本号, so that 知道装的是哪一版
63. As a 用户, I want 没有登录、没有账号、没有云, so that 桌面钟不需要网络
64. As a 开发者, I want 用假 Clock 快进墙上时间和单调时间, so that 不用真等 25 分钟测 Complete
65. As a 开发者, I want 时间数学的测试不 pump 整页, so that 测试稳定且快

## Implementation Decisions

- 新建一个深模块 ClockEngine，作为本特征唯一对外测试缝。Riverpod 只做适配，把 snapshot 交给 UI，不在 Provider 或 Widget 里算时间。
- Clock 端口注入 ClockEngine：提供墙上 `now` 和单调 `elapsed`。生产适配器用设备时钟；测试适配器可冻结、分别快进两种时间。
- ClockEngine 持有可选 Session 与显示相关设置（时间制、是否显示秒、Night Mode）。ClockTheme id 存在设置里，由面孔 Renderer 读取；Engine 不负责画。
- 持久化注入为存储端口（生产用 SharedPreferences，测试用内存）。存：设置、运行中 Session、今日 Focus Complete 列表。不引入 Isar。
- Session 一种状态机，`kind` 为 focus 或 timer。状态：idle（无 Session）/ running / paused / complete。同时最多一个。
- 墙上显示从 `now` 派生，不每秒累加。有秒则对齐下一秒跳变；无秒则对齐下一分钟。Session 剩余从单调 elapsed 派生，运行中始终 `mm:ss`，忽略「显示秒」设置。
- Start：写入 kind、duration、单调起点。Pause：把 remaining 冻住。Resume：用当前 elapsed 做新起点继续扣 remaining。Stop：丢弃 Session，不写统计。Complete：remaining 到 0；仅 focus 的 Complete 追加一条今日记录（duration 分钟、本地日历日）。
- 用户确认 Complete（Done）后回到墙上时间。
- 进程被杀：同一次开机用单调 elapsed 恢复；若剩余已到 0 则直接 complete。重启后 elapsed 归零：视为 Pause，remaining 冻结。
- App 进入后台：不自动 Pause。按当时 remaining 预约一条本地通知；回前台若尚未 Complete 则取消预约。不靠后台 Dart timer 触发提醒。不做前台服务。
- 通知权限在第一次 Start 时申请。拒绝则 Session 照跑，无后台通知。
- 主路由只有 Clock。Theme / Focus / Timer 选择器是 sheet。Complete 是 Clock 上的状态。Settings 与 About 是子路由。删除 Splash、Welcome、Login、Dio、Token。
- 横屏是同一 Clock 的自适应布局，不锁方向，没有横屏路由。
- ClockTheme 目录内置四套（Minimal、Flip、OLED、Retro），只持久化 id。共用外壳（时间源、操作栏、方向）；脸按 type 分发 Renderer。Flip 在显示数字变化时翻页。去掉 AdaptiveTheme；Settings chrome 固定深色。
- Night Mode 是显示策略，不换 ClockTheme：字改暗、隐藏日期和秒、暂时降低系统亮度，退出恢复。V1 无 Auto。
- Keep Awake 默认开；仅 Clock（含 Session）页持有 wakelock，进 Settings 释放。
- 空闲操作栏：Theme / Focus / Timer / More。运行中：Pause / Stop。三秒无操作隐藏。Clock 隐藏系统栏；Settings 恢复。
- Focus 预设 15/25/45/60，突出 25。Timer 预设 1/5/10/30。Custom：Focus 1–90 分钟，Timer 1–180 分钟，步进 1 分钟。
- 今日统计只在 Focus 选择 sheet 底部。日期文案跟设备 locale。12/24 默认跟设备，可改。12 小时制必显 AM/PM，无独立开关。
- 声音与震动尊重设置。About 只展示版本号。

ClockEngine 对外形状（Grill 结论，不是原型代码）：

```
Clock
  wallNow() -> DateTime
  elapsed() -> Duration

SessionKind = focus | timer
SessionStatus = running | paused | complete

ClockSnapshot
  wall time fields (hour, minute, second?, date, period?)
  session?: { kind, remaining, status }
  nightMode
  showSeconds   // 只影响 wall
  timeFormat

ClockEngine
  snapshot: ClockSnapshot
  start(kind, duration)
  pause()
  resume()
  stop()
  acknowledgeComplete()
  // 设置变更走同一模块，使 snapshot 立即反映
```

调用方和测试都只通过上述界面。假 Clock 快进后读 snapshot，不断言内部计时器。

## Testing Decisions

- 只测 ClockEngine 的外部行为：给定 Clock 与存储，命令之后 snapshot / 今日统计 / 持久化读回必须符合不变量。不断言 tick 实现、Provider 图、Widget 树。
- 好测试：Arrange 假 Clock 与内存存储 → Act start/pause/advance/resume/stop/杀进程重载 → Assert snapshot 与今日条数。时间用快进，不 `pump` 真实时长。
- 覆盖至少：墙上 12/24 与 AM/PM；秒开则每秒跳、关则整分跳；Start Focus/Timer；Pause/Resume 同一 Session；Stop 不记账；elapsed 到 duration 则 Complete 且仅 focus 记账；今日 0:00 分界；墙上时间跳变不影响 remaining；同开机重载按 elapsed；重启标记后为 Pause；同时不能 start 第二个 Session。
- 通知调度、系统亮度、wakelock、GoRouter 是薄系统适配，不作为第二测试缝。它们消费 snapshot / Complete，不复制时间数学。
- 现有测试只有「启动到 Welcome」的 widget 测试，与 V1 冲突，应删掉或改成「第一帧是 Clock」的冒烟；时间正确性仍以 Engine 测试为准。仓库里没有可沿用的 Engine 测试样板。

## Out of Scope

Alarm、秒表、世界时钟、天气、登录、云同步、后端、AI、社交、Todo、睡眠、Health、白噪音、Home/Lock Widget、Dynamic Island、Watch、Wear。Night Mode Auto。Isar。前台服务。周/月统计、图表、Streak、Achievement。应用内语言开关。自定义 Theme / 字体 / 背景。V1.5/V2 的 Scene、白噪音、Premium。品牌向 About 页。

## Further Notes

术语见根目录 `CONTEXT.md`。决策见 `docs/adr/`（0001–0018）。实现时若与 ADR 冲突必须显式指出，不得默默改掉。
