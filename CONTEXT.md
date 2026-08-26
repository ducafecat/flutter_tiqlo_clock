# Tiqlo

全屏桌面时钟。Clock 永远是表面；Focus 和 Timer 是临时替换显示时间的 Session。

## Language

**Clock**:
始终可见的墙上时间表面，显示当前时、分和日期。可选秒只作用于墙上时间，不影响 Session。12 小时制必显 AM/PM，24 小时制不显。
_Avoid_: Home, 首页, Dashboard, HomePage

**now**:
当前墙上时刻。只驱动 Clock 的时分秒和日期。不是 Session 剩余时间的来源。
_Avoid_: ticker, DateTime.now, 系统时间, elapsed

**Session**:
用单调时钟计量的倒计时，临时替换 Clock 上的墙上时间。种类只有 Focus 和 Timer。同时只允许一个。运行中始终显示 `mm:ss`，操作只有 Pause / Stop。
_Avoid_: countdown（当作实体）, clock mode, 时钟模式, deadline（墙上截止时间）

**Focus**:
一种 Session。只有 Complete 才记入今日次数和分钟。Stop 不算。Pause 再 Resume 仍是同一次。今日统计只出现在 Focus 选择 sheet，不常驻 Clock。
_Avoid_: 番茄钟, Pomodoro

**Timer**:
一种 Session。倒计时并提醒，不记入 Focus 统计。
_Avoid_: 秒表, Alarm, 闹钟

**Pause**:
冻结 Session，保存 remaining；Resume 从新的单调原点继续扣 remaining。仍是同一次 Session。设备重启后的未完成 Session 视为 Pause。
_Avoid_: Stop, 中断

**Stop**:
用户中止 Session。不写入今日统计。Clock 回到墙上时间。
_Avoid_: Cancel（产品动作是 Stop；Timer 入口文案若写 Cancel，仍映射为 Stop）

**Complete**:
Session 的单调剩余走到 0。Focus 的 Complete 才记今日统计。提醒后用户确认，Clock 回到墙上时间。
_Avoid_: Done（Done 只是 Complete 画面上的按钮）

**Today**:
本地日历日，0:00 分界。Focus 统计按 Complete 落在哪一天。
_Avoid_: 滚动 24 小时, UTC 日

**ClockTheme**:
Clock 的时间呈现样式，种类只有 Flip 和 Digital；两者分别保留自己的配色选择。与 Pixel UI 和 Night Mode 独立，目录内置，只记住当前样式 id。
_Avoid_: Theme, Material Theme, App Theme, AdaptiveTheme, 主题（无限定）

**Pixel UI**:
覆盖全部运行时界面的统一视觉语言，使用固定深色 chrome、像素字体、阶梯几何和硬边交互状态。它不改变 ClockTheme、Clock 配色或产品行为。
_Avoid_: Pixel Theme, 像素主题, ClockTheme

**Night Mode**:
显示策略：字改暗、隐藏日期和秒、暂时降低系统亮度。可叠在任意 ClockTheme 上。V1 只有手动开关；退出后恢复亮度。
_Avoid_: Dark Mode, OLED, Night Theme, Night Clock, 夜间主题, Auto Night
