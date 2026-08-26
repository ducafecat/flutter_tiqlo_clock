# 01: 建立 Pixel UI 并改造设置类界面

**What to build:** 建立 Tiqlo 的 Pixel UI 深模块，并让用户在 About 与 Settings 中获得第一条完整、可访问、可持久化的 Pixel UI 体验。字体、颜色、阶梯几何、硬阴影和交互状态由统一接口提供；页面只表达内容、设置状态与回调。

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

- [ ] Silkscreen、Pixelify Sans 与 Tiny5 使用固定的官方 OFL-1.1 构建随项目分发，并保留各自许可证、版权、来源和版本信息
- [ ] Flip Display、Digital Display、Heading、Body / Label、HUD 与中文 fallback 的字体角色符合已确认规格
- [ ] PixelTokens 通过固定深色 ThemeExtension 提供颜色、排版、间距、描边、阴影和动效语义，且不与 ClockTheme 或 Night Mode 混用
- [ ] Pixel UI 的阶梯几何、DPR 描边对齐、硬阴影及 reduced-motion 判断隐藏在公开接口之后
- [ ] PixelPanel、PixelButton、PixelIcon、PixelSection 与 PixelSwitch 通过语义状态和回调使用，不读取业务 provider 或持久化存储
- [ ] 所有通用交互覆盖 rest、hover、pressed、focus、selected 和 disabled；pressed 使用 2dp 位移且不显示圆形水波纹
- [ ] About 使用固定深色 Pixel chrome、像素返回图形和最大 720dp 正文宽度，并继续只显示版本信息
- [ ] Settings 使用 Pixel 标题、三个分组、阶梯容器、分隔线和 PixelSwitch，不再显示默认 Material 圆角控件
- [ ] 24 Hour、Show Leading Zero、Show Seconds、Date & Weekday、Keep Screen Awake、Night Mode、Sound、Vibration 的默认值、整行点击、即时状态与持久化行为保持不变
- [ ] Settings 每项形成单一可切换语义节点，支持触控、Tab、Shift-Tab、Enter、Space 和至少 48×48dp 操作目标
- [ ] About 与 Settings 在 Compact、Medium、Expanded、横竖屏及 2.0× 文字缩放下无溢出且内容可达
- [ ] 测试只断言 Pixel UI 公开行为、页面可观察结果和 ClockEngine 状态，不锁定私有 painter、Path、Widget 嵌套或旧 Material 类型

