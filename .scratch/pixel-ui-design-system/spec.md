# Tiqlo Pixel UI Design System

Status: ready-for-agent

## Problem Statement

Tiqlo 当前的 Clock、Theme、More、Settings、About、Splash、Welcome 和 Session 状态由多套零散的 Material 样式、硬编码颜色、连续圆角与不同字体组成。用户无法从这些界面感受到统一的产品身份；Flip 的现有外观、默认 Material 控件和设计稿中的 Minimal Pixel UI 之间也存在明显差距。同时，当前测试有一部分锁定了具体 Material Widget 和内部绘制结构，使视觉重构容易误伤既有 ClockTheme、Night Mode、持久化、全屏和 Session 行为。

## Solution

建立一套固定深色、可复用、可访问、跨尺寸的 Pixel UI 深模块，并用它改造当前项目全部运行时界面。Pixel UI 统一颜色、排版、阶梯几何、描边、硬阴影、交互状态、键盘、语义和 reduced motion；页面只提供业务状态与回调。Flip 使用 Silkscreen 与机械翻页卡片，Digital 保留 DSEG7Classic，应用标题和正文使用 Pixelify Sans，短 HUD 使用 Tiny5。ClockTheme palette、Night Mode、路由、偏好键和 Session 行为保持不变。

## User Stories

1. As a Tiqlo 用户, I want 所有运行时界面使用同一套 Pixel UI, so that App 从启动到设置都具有一致的产品身份
2. As a Tiqlo 用户, I want Clock 始终是画面的视觉中心, so that 像素风不会削弱桌面时钟的核心用途
3. As a Tiqlo 用户, I want 在远距离仍能清楚辨认时间, so that 手机横放或竖放在桌面上都实用
4. As a Tiqlo 用户, I want Flip 使用清晰的 Silkscreen 大数字, so that 翻页钟具有明确的像素个性
5. As a Tiqlo 用户, I want Flip 卡片具有统一的阶梯切角、描边、中轴和轴件, so that 它看起来像完整的机械像素钟而不是普通圆角卡片
6. As a Tiqlo 用户, I want Flip 数字变化时卡片外框和中轴保持稳定, so that 动画不会产生布局跳动
7. As a Tiqlo 用户, I want Flip 翻页在 600ms 内完成, so that 动画兼顾机械感与连续秒数的可读性
8. As a 开启减少动态效果的用户, I want Flip 直接替换数字, so that App 尊重我的系统动效偏好
9. As a 12 小时制用户, I want AM/PM 以 Tiny5 HUD 显示在小时卡左上角, so that 周期信息清晰但不抢占主数字
10. As a 24 小时制用户, I want 小时卡不保留 AM/PM 空位, so that 卡片空间充分用于时间
11. As a Tiqlo 用户, I want 开启秒数后出现同规格的第三张 Flip 卡片, so that 秒数不会破坏整体比例
12. As a Tiqlo 用户, I want 竖屏时 Flip 卡片纵向排列、横屏时横向排列, so that 同一个 Clock 能自然适配方向
13. As a Tiqlo 用户, I want Digital 保留 DSEG7Classic 与无卡片的极简表面, so that Digital 和 Flip 仍是两种不同的 ClockTheme
14. As a Tiqlo 用户, I want Digital 保留现有九组配色, so that Pixel UI 改造不会删除我的选择
15. As a Tiqlo 用户, I want Flip 保留现有十组配色, so that Pixel UI 改造不会覆盖 ClockTheme palette
16. As a Tiqlo 用户, I want 应用 chrome 始终使用固定深色 Pixel UI, so that Clock 配色变化不会让菜单和设置失去一致性
17. As a Tiqlo 用户, I want Night Mode 继续叠加在任何 ClockTheme 上, so that 夜间显示策略不会被误做成另一套主题
18. As a Tiqlo 用户, I want Night Mode 继续隐藏日期和秒并降低视觉强度, so that 现有床头使用行为不回归
19. As a Tiqlo 用户, I want 点击 Clock 后看到像素化的文字操作栏, so that Theme、More 和全屏入口与时钟风格一致
20. As a Tiqlo 用户, I want Clock 操作栏继续在三秒无操作后隐藏, so that Clock 能恢复沉浸显示
21. As a 桌面或 Web 用户, I want Fullscreen 与 Exit Fullscreen 的文字状态正确变化, so that 我能清楚知道当前操作
22. As a Tiqlo 用户, I want Theme 从统一的 PixelSheet 打开, so that 主题选择不再使用默认 Material bottom sheet
23. As a Tiqlo 用户, I want Theme Sheet 打开时保留 Clock 实时预览, so that 选择结果能够立即判断
24. As a Tiqlo 用户, I want Flip 与 Digital 的样式选择项同时使用描边、表面和勾选表达选中, so that 状态不只依赖颜色
25. As a Tiqlo 用户, I want 十组 Flip 配色和九组 Digital 配色完整展示, so that 当前产品目录保持不变
26. As a Tiqlo 用户, I want 配色网格根据宽度自动换列, so that 小手机、平板和桌面都不会溢出或过度拉伸
27. As a Tiqlo 用户, I want Theme 选择立即保存且关闭时不回滚, so that 不需要额外确认按钮
28. As a 触屏用户, I want 下拖 Theme 或 More 面板即可关闭, so that 交互符合移动端习惯
29. As a 键盘用户, I want Escape 能关闭 PixelSheet, so that 桌面与 Web 操作完整
30. As a 键盘用户, I want PixelSheet 打开后焦点留在面板内并在关闭后回到触发按钮, so that 不会丢失操作位置
31. As a Tiqlo 用户, I want More 保持 Night Mode、Settings、About 三项, so that 视觉改造不改变信息结构
32. As a Tiqlo 用户, I want More 中的 Night Mode 使用 PixelSwitch, so that 快捷设置与 Settings 页面一致
33. As a Tiqlo 用户, I want Settings 和 About 使用 PixelActionTile, so that 导航动作不会被误认为选择状态
34. As a Tiqlo 用户, I want Settings 保留 Time & Date、Display、Alerts 三组, so that 已熟悉的信息结构不改变
35. As a Tiqlo 用户, I want 八个设置项及其默认值保持不变, so that 更新后不需要重新学习或配置
36. As a Tiqlo 用户, I want 点击设置项整行都能切换, so that 操作目标足够大且容易触达
37. As a Tiqlo 用户, I want PixelSwitch 用阶梯轨道和滑块表达开关, so that 设置控件不再出现圆润 Material 胶囊
38. As a Tiqlo 用户, I want PixelSwitch 在 150ms 内完成状态移动, so that 反馈短促而明确
39. As a Tiqlo 用户, I want Settings 和 About 使用像素化返回图形, so that 页面 chrome 不混入默认 Material 图标
40. As a Tiqlo 用户, I want About 继续只显示版本信息, so that 视觉重构不会偷偷增加产品内容
41. As a 首次启动用户, I want Welcome 保留现有三张插画和中文文案, so that 已有引导内容不被重做
42. As a 首次启动用户, I want Welcome 的按钮、文字和分页器使用 Pixel UI, so that 引导 chrome 与主应用一致
43. As a 首次启动用户, I want 继续左右滑动 Welcome 页面并使用跳过、下一步和开始使用, so that 现有启动行为不改变
44. As a 开启减少动态效果的首次启动用户, I want Welcome 按钮翻页直接跳转, so that 引导尊重系统偏好
45. As a 移动端用户, I want Splash 保留现有插画但只做 300ms 淡入, so that 启动画面更克制且不再缩放
46. As a 开启减少动态效果的移动端用户, I want Splash 直接显示, so that 启动阶段也不强制播放动画
47. As a 恢复到运行中 Session 的用户, I want 看到 Pixel UI 的 `mm:ss` 与 FOCUS 或 TIMER 标签, so that 潜在运行状态不会成为视觉断层
48. As a 暂停 Session 的用户, I want 明确看到 PAUSED 标签和冻结时间, so that 暂停不会与运行中画面混淆
49. As a Session Complete 用户, I want 看到 COMPLETE 与既有时长信息, so that 完成状态清晰且不增加新的流程
50. As a Session 用户, I want Pause、Resume、Stop、Done 的行为保持原样, so that 视觉重构不会改变 Session 状态机
51. As a Session 用户, I want Session 继续继承当前 ClockTheme palette, so that 倒计时与当前 Clock 视觉连贯
52. As a 用户, I want 破坏性的 Stop 使用独立危险状态, so that 它与普通操作容易区分
53. As a 鼠标用户, I want 所有操作控件提供明确 hover 状态, so that 我能看出当前指向的目标
54. As a 键盘用户, I want 所有操作控件提供与 selected 不同的高对比 focus 状态, so that 焦点位置明确
55. As a 触控用户, I want pressed 状态具有 2dp 位移与硬阴影变化, so that 不依赖圆形水波纹也能感知按下
56. As a 用户, I want disabled 状态仍可辨认但不能响应, so that 控件状态不会含糊
57. As a 低视力用户, I want 正常模式的文字和 Clock 数字达到至少 4.5:1 对比度, so that 内容保持可读
58. As a Night Mode 用户, I want 大号时间仍达到至少 3:1 且操作 chrome 保持 4.5:1, so that 降亮不等于无法使用
59. As a 触控用户, I want 所有操作目标至少 48×48dp, so that 控件容易准确点击
60. As a 放大文字的用户, I want 2.0× 文字缩放下内容仍可滚动访问且不截断, so that App 不因字体放大失效
61. As a 屏幕阅读器用户, I want Clock 时间只朗读一次, so that Flip 的重复数字层和装饰不会制造噪音
62. As a 屏幕阅读器用户, I want 设置项名称、开关状态和切换动作组成单一语义节点, so that 每一行不会重复朗读
63. As a 屏幕阅读器用户, I want 配色名称及 selected 状态被正确朗读, so that 不看颜色也能选择 ClockTheme palette
64. As a 键盘用户, I want 使用 Tab、Shift-Tab、Enter 和 Space 操作所有可交互项, so that 桌面与 Web 不依赖鼠标
65. As a 中文用户, I want 中文使用平台系统字体回退, so that 像素字体缺字不会损害可读性
66. As a Tiqlo 用户, I want 页面标题使用 Pixelify Sans SemiBold、短正文使用 Regular, so that 信息层级清晰而不过度复古
67. As a Tiqlo 用户, I want AM/PM 与短状态 HUD 使用 Tiny5, so that 仪表信息与主数字形成明确层级
68. As a 发布负责人, I want 三款新增字体的 OFL 许可证和固定来源随项目保留, so that 商业 App 分发可追溯且合规
69. As a 开发者, I want 页面只使用 Pixel UI 的语义接口, so that 切角、DPR、硬阴影和输入状态不会散落在调用方
70. As a 开发者, I want Pixel UI 的外部行为通过稳定接口测试, so that 内部绘制重构不需要重写页面测试
71. As a 开发者, I want Android、iOS、Tablet、macOS 与 Web 有固定视觉回归基线, so that 跨尺寸变化可被复现和审查
72. As a Windows 或 Linux 用户, I want App 保证编译与基本布局可用, so that 非主要 golden 平台不会被整体改造遗忘

## Implementation Decisions

- Pixel UI 覆盖当前实际存在的运行时 UI：Splash、Welcome、Clock、Flip、Digital、Clock chrome、Theme、More、Settings、About，以及可能由恢复数据触发的 Session running、paused、complete 状态。
- 不新增 Focus 或 Timer 入口、selector、统计页面、咖啡流程或主导航；概念图只作为像素氛围参考。
- 现有路由、SharedPreferences 键、ClockEngine、ClockSnapshot、ClockThemeId、FlipPaletteId、DigitalThemeId 和 Session 行为保持不变。
- ClockTheme 的当前目录只有 Flip 与 Digital；两者分别保留自己的 palette。Pixel UI 与 ClockTheme、Night Mode 是三个不同概念。
- Pixel chrome 固定深色，不跟随 ClockTheme palette 或系统亮暗主题变化。Night Mode 继续作为独立显示策略。
- Pixel UI 使用不可变 ThemeExtension 承载颜色、字体、间距、描边、阴影与动效 token。
- 基础颜色包括 background、chrome、surface、surfaceHigh、textPrimary、textSecondary、outline、accent、section、shadow，并补充 focus、danger、disabledSurface、disabledText、barrier、hoverOverlay、pressedOverlay。
- 页面不散落硬编码视觉值；最终颜色可为满足真机观感和对比度微调，但语义关系不可改变。
- Pixel UI 是深模块。公开接口包括 PixelTheme / PixelTokens、PixelPanel、PixelButton、PixelActionTile、PixelSelectionTile、PixelColorOption、PixelSwitch、PixelSection、PixelToolbar、PixelSheet、PixelPageIndicator 和 PixelIcon。
- 页面只向 Pixel UI 传入语义状态和回调。Riverpod provider、SharedPreferences、Clock 配色目录与业务副作用不进入 Pixel UI。
- 阶梯 Path / ShapeBorder、DPR 描边对齐、硬阴影计算、hover / pressed / focus 绘制和 reduced-motion 判断均隐藏在 Pixel UI 实现内部。
- FlipCard 属于 Clock feature，不成为通用 Pixel UI 接口；它消费 token 并保留现有上下半层裁剪和 rotateX 翻页算法。
- 像素几何以 4dp 为基础网格。切角只使用 8dp、12dp、16dp 三个等级；页面不得创造任意圆角或切角值。
- 描边默认 1–2dp，由统一实现按 DPR 对齐物理像素。阴影使用短距离、低模糊或零模糊硬边。
- 通用间距序列为 4、8、12、16、24、32dp。Settings 行不低于 64dp，所有交互目标不低于 48×48dp。
- 响应式只使用 Compact `<600dp`、Medium `600–1023dp`、Expanded `≥1024dp` 三档；`≤360dp` 仅触发紧凑间距。方向是独立布局轴，不产生新路由。
- Theme 的 Compact 竖屏最大高度为 78%，Compact 横屏最大高度为 92%；Medium / Expanded 最大宽度 720dp、最大高度 80%。配色项最小宽度 144dp 并自动换列。
- Settings 与 About 正文最大宽度 720dp。More 按内容自适应高度，同时受 SafeArea 和可用高度限制。
- PixelSheet 支持移动端拖拽关闭、点击遮罩关闭、系统返回、Escape、独立滚动、焦点限制与关闭后焦点恢复。
- Theme 选择即时预览并自动持久化，不提供确认按钮，关闭面板不回滚选择。Flip 与 Digital 的 palette 分别记忆。
- 所有交互接口统一覆盖 rest、hover、pressed、focus、selected、disabled。Pressed 下移 2dp 并缩短硬阴影；默认不显示圆形水波纹。
- PixelIcon 初始只提供 back、check 和拖拽把手所需的最小像素图形。Clock 与 Session 操作继续以清晰文字为主，不强行图标化。
- Flip 使用 Silkscreen Bold；Digital 保留 DSEG7Classic；Heading 使用 Pixelify Sans 600；Body / Label 使用 Pixelify Sans 400；HUD 使用 Tiny5 Regular。
- Tiny5 只用于 AM/PM、FOCUS、TIMER、PAUSED 等短 HUD，建议不低于 14sp；不用于说明文字、主题名称或通用 Caption。
- 中文和像素字体缺失字符使用平台系统字体回退。长段落也优先系统字体，不以低分辨率栅格化伪造像素效果。
- Silkscreen、Pixelify Sans 与 Tiny5 使用未经修改的 OFL-1.1 官方构建，固定文件版本或 commit 并保留各自许可证、版权信息、来源和获取日期。
- Pixelify Sans 支持 400–700 字重；若使用可变字体文件，只提交固定的一种构建方式并验证 w400 与 w600，不同时混入未使用的静态和可变版本。
- Flip 动画固定 600ms，PixelSwitch 固定 150ms，按压和焦点反馈 100ms，Welcome 按钮翻页 300ms，Welcome 文案和分页器 150ms，Splash 淡入 300ms。
- 系统关闭动画时，Flip 直接替换数字、Splash 直接显示、Welcome 直接跳页、控件立即更新；不新增弹跳、视差或像素抖动。
- Flip 竖屏纵排、横屏横排。小时、分钟和可选秒数卡片保持同一比例和视觉重量。12 小时制的 AM/PM 使用 Tiny5，24 小时制不保留空位。
- Digital 不增加 Flip 式卡片；只统一日期、AM/PM、Session、Clock chrome 和共享交互语言。
- Clock chrome 保留 Theme、More 和受支持平台的 Fullscreen / Exit Fullscreen，并保留三秒自动隐藏行为。
- Session 继续继承当前 ClockTheme palette。Running 显示 mm:ss 与 FOCUS / TIMER；Paused 增加 PAUSED；Complete 显示 COMPLETE 与既有时长信息。操作仍严格为 Pause / Resume / Stop / Done。
- More 内容严格保持 Night Mode、Settings、About。Settings 严格保持现有三组、八个设置项、默认值、整行点击和持久化行为。About 严格只显示版本信息。
- 保留现有 Splash 与三张 Welcome 插画。Welcome 保留三页、中文文案、滑动、跳过、下一步和开始使用；只替换文字、按钮、分页器、间距和交互状态。
- 正常模式文字和 Clock 数字对比度至少 4.5:1；必要图形、焦点框和开关边界至少 3:1；Night Mode 大号时间允许 3:1，但操作 chrome 仍需 4.5:1。
- 装饰性轴件、阴影、像素角、拖拽把手和 Flip 重复数字层不进入语义树。Clock 时间只朗读一次；Settings 每行只形成一个可切换语义节点。
- 改造按设计系统基础、Clock / Flip / Digital / Session、Theme、Settings / More / About、Splash / Welcome / 视觉校准五阶段推进。开发期间可短暂并存旧 Material UI，完成时不得保留可见旧控件，也不增加 feature flag。

## Testing Decisions

- 主要新测试 seam 是 Pixel UI 深模块的公开接口。测试通过公开语义参数、输入事件和渲染结果验证行为，不跨过接口断言私有 painter、Path、Widget 嵌套或 BoxDecoration 类型。
- 页面级 Widget 测试是第二层组合 seam，用于验证 Clock、Theme、More、Settings、About、Welcome 与 Session 如何把业务状态和回调交给 Pixel UI；它不复制模块内部状态测试。
- 现有 ClockEngine 测试 seam 保持不变，负责证明 ClockTheme、palette、Settings、Night Mode、Session、提醒和持久化行为未被视觉改造改变。
- 好测试描述用户可观察结果：显示什么、能否点击或键盘操作、语义读到什么、选择是否保存、滚动是否可达、布局是否溢出。坏测试锁定具体 Material Widget 类型、私有 Stack 层级、Container 或 Decoration 实现。
- PixelButton、PixelActionTile、PixelSelectionTile、PixelColorOption、PixelSwitch、PixelSheet、PixelToolbar、PixelPageIndicator 和 PixelIcon 均通过公开接口覆盖 rest、hover、pressed、focus、selected、disabled 和 reduced-motion 行为。
- PixelSwitch 测试覆盖 on / off、整行点击、Space / Enter、disabled、单一语义节点、状态立即更新。PixelSelectionTile 与 PixelColorOption 覆盖名称、selected、键盘、hover、focus 和非颜色状态标记。
- PixelSheet 测试覆盖拖拽、遮罩、返回键、Escape、焦点限制、焦点恢复、内部滚动、即时保存不回滚及 2.0× 文字下滚动到底。
- Clock 语义测试只暴露一个完整时间节点。Flip 静止层、动画层、中轴和轴件不得重复朗读。
- Flip 测试保留数字连续、翻页两阶段、divider 与外框稳定、12 / 24 小时、前导零、秒数、日期、Night Mode 和横竖屏组合，但动画时间点从统一 motion token 推导，不硬编码旧 1000ms 实现。
- Theme 测试保留两种 ClockTheme、Flip 十组 palette、Digital 九组 palette、即时预览、独立记忆和重启恢复。查找控件使用稳定 key 或语义，不断言 ListTile、ChoiceChip 等旧 Material 类型。
- Settings 测试保留三组八项、生产默认值、整行点击、即时状态和持久化。断言 Engine 与语义状态，不读取 SwitchListTile 实例。
- Session 测试保留 Pause / Resume / Stop / Done、Focus Complete 统计与 Timer 不记统计等现有行为，并增加 PAUSED、COMPLETE 和 PixelToolbar 可见状态断言。
- Splash / Welcome 测试保留首次启动路径、三页、跳过和开始使用，并覆盖正常动画与 reduced motion。
- 固定回归矩阵为：Android 360×640 / 1.0×，iOS 844×390 / 1.3×，Tablet 1024×768 / 2.0×，macOS 1280×800 / 1.0×，Web 1440×900 / 2.0×。Windows / Linux 保证编译与基本布局，不作为逐像素基线。
- Golden 至少覆盖 Flip、Digital、Theme、More、Settings、Welcome 和 About。字体文件、版本、viewport、DPR 与文字缩放必须固定；每次更新基准必须作为明确的视觉决策审查。
- Android 竖屏覆盖三卡 Flip、日期、Theme 与 Settings 滚动；iOS 横屏覆盖 SafeArea、横排 Clock 和 Theme；Tablet 覆盖网格降列与设置行增高；macOS 覆盖 hover、focus、键盘和全屏；Web 覆盖最大宽度、滚动与焦点轮廓。
- 改造后保留现有业务回归测试；只删除已经被更高 seam 的外部行为测试取代、且纯粹锁定旧 Material 实现的测试。

## Out of Scope

- 新增 Focus 或 Timer 入口、selector、预设、自定义时长或统计页面
- `focus.png` 中的咖啡机、Pour、Break、History、Profile、底部导航和多阶段流程
- 新增 ClockTheme、palette、主题商店、下载或付费主题
- 修改 ClockEngine、ClockSnapshot、Session 状态机或 Focus 统计语义
- 修改路由结构、SharedPreferences 键、通知权限时机或平台副作用顺序
- 自动 Night Mode、环境光感知、系统主题联动或新的 Material 亮暗主题
- 重做 Splash / Welcome 插画、应用图标或原生启动图
- 为桌面创建独立路由或为横屏复制页面
- 使用整页位图、Lottie、视频或逐帧 PNG 替代动态 Flutter UI
- 新增 About 内容、许可浏览页、隐私、反馈或品牌页面
- 运行时下载字体、修改上游字体或把字体文件作为独立商品分发

## Further Notes

- 产品术语以根领域词表为准：ClockTheme 当前只有 Flip 与 Digital；Pixel UI、ClockTheme、Night Mode 不得混称。
- 视觉和交互细节以已确认的像素风实施方案为准。冲突优先级为：现有 ADR 与已确认产品行为，其次是方案中的语义规则与 token，再其次是设计稿视觉意图，最后才是当前 Material 外观。
- ADR-0003 的核心决定“ClockTheme 不是 Material Theme，Settings 使用固定深色 chrome”继续有效；其中 Minimal / Flip / OLED / Retro 的旧枚举与当前代码及领域词表冲突，应视为过时描述，不得据此恢复已不存在的 ClockTheme。
- ADR-0004 的“横屏是布局而非路由”、ADR-0011 的“Clock 是唯一主路由”、ADR-0014 的“Session 运行中只允许 Pause / Stop”、ADR-0017 的 Night Mode 亮度策略均必须保留。
- 三款新增字体允许在商业 App 中嵌入和分发，但必须保留 OFL-1.1 许可证与版权信息；应用商店最终发布仍需遵守平台及目标地区要求。
