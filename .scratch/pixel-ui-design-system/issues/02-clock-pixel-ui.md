# 02: 完成 Clock 全链路 Pixel UI

**What to build:** 将 Clock 及其所有现存瞬态界面完整迁移到 Pixel UI。用户可以在统一的 Clock chrome 中打开 More 与 Theme、即时切换 Flip / Digital 和各自 palette，并在 Clock 或既有 Session 状态中获得一致、可访问、响应式且尊重减少动态效果的体验。

**Blocked by:** 01 / 建立 Pixel UI 并改造设置类界面

**Status:** ready-for-agent

- [ ] Clock 页面的 Theme、More、Clock chrome 与平台副作用协调逻辑形成可独立修改的 seam，重构本身不改变路由、生命周期或业务行为
- [ ] PixelSheet、PixelActionTile、PixelSelectionTile、PixelColorOption 与 PixelToolbar 通过 Pixel UI 公开接口提供完整交互行为
- [ ] More 仍只包含 Night Mode、Settings、About，并支持拖拽、遮罩、系统返回、Escape、焦点限制、焦点恢复和自适应高度
- [ ] Theme 打开时保留 Clock 实时预览；Flip / Digital 选择与十组 / 九组 palette 完整、即时生效、独立记忆且关闭时不回滚
- [ ] Theme 配色项最小宽度 144dp 并自动换列；Compact 竖屏、Compact 横屏、Medium 与 Expanded 的宽高约束符合规格
- [ ] Clock 空闲 chrome 保留 Theme、More 和受支持平台的 Fullscreen / Exit Fullscreen，并继续在三秒无操作后自动隐藏
- [ ] Digital 保留 DSEG7Classic、无卡片时间表面及九组 palette，不被 Silkscreen 或 Flip 卡片外观覆盖
- [ ] Session running 显示 mm:ss 与 FOCUS / TIMER，paused 额外显示 PAUSED，complete 显示 COMPLETE 与既有时长信息
- [ ] Session 继续继承当前 ClockTheme palette，且 Pause、Resume、Stop、Done、提醒、统计和持久化行为保持不变
- [ ] Flip 使用 Silkscreen Bold 主数字、Tiny5 AM/PM、阶梯卡片、稳定中轴、对称轴件和现有上下半层 rotateX 算法
- [ ] Flip 翻页固定 600ms，外框与布局在两个阶段保持稳定；系统关闭动画时直接替换数字
- [ ] Flip 在竖屏纵向、横屏横向排列；小时、分钟和可选秒数卡片保持相同比例，12 / 24 小时、前导零、日期和 Night Mode 组合无回归
- [ ] Clock 时间只形成一个可读语义节点；重复数字层、轴件、阴影、切角和拖拽把手不进入语义树
- [ ] Clock、More 与 Theme 支持触控、鼠标、hover、focus、键盘和 2.0× 文字缩放，正常模式对比度与 Night Mode 最低对比度符合规格
- [ ] 主题、设置、Clock chrome、Flip、Digital 与 Session 的现有业务测试保持通过；受视觉替换影响的测试改为稳定 key、语义或外部结果断言

