# iOS App Store 元数据与搜索优化研究

> 调研日期：2026-08-25  
> 适用对象：Tiqlo Clock iOS App Store 商品页  
> 资料范围：仅使用 Apple Developer 和 App Store Connect Help 官方一手资料。Apple 会持续调整搜索算法，本文不对排名效果做保证。

## 执行摘要

- App Store 应用内搜索的明确文本相关性信号是：**App 名称、副标题、关键词和主分类**。下载、评分及评论的数量与质量等用户行为也参与排名。[来源：App Store search](https://developer.apple.com/app-store/search/)
- **推广文本不影响搜索排名**，不应把关键词堆在此字段。[来源：App Store search](https://developer.apple.com/app-store/search/)
- Apple 只明确说明描述会被用于发布后的 **Web 搜索引擎结果**；官方的 App Store 应用内搜索排名信号列表没有将描述列入。因此，描述应优先服务转化、准确介绍和站外搜索，不应为 App Store 内排名堆词。[来源：Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) [来源：App Store search](https://developer.apple.com/app-store/search/)
- 对 Tiqlo Clock，Apple 在分类定义中直接把 **clocks / time** 列为 Utilities（工具）示例，因此建议主分类从 Productivity（效率）调整为 **Utilities（工具）**，次分类保留 **Productivity（效率）**。这是基于 Apple 分类定义做出的项目建议。[来源：Choosing a category](https://developer.apple.com/app-store/categories/)

## 字段规则与搜索作用

| 字段 | Apple 限制 | 是否明确影响 App Store 应用内搜索 | 官方依据 |
| --- | --- | --- | --- |
| App 名称（Name / Title） | 2–30 个字符；可本地化 | **是**，文本相关性信号；公司名也可被搜索 | [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information) 、[App Store search](https://developer.apple.com/app-store/search/) 、[Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) |
| 副标题（Subtitle） | 最长 30 个字符；可本地化 | **是**，文本相关性信号 | [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information) 、[App Store search](https://developer.apple.com/app-store/search/) |
| 关键词（Keywords） | App Store Connect 参考页写“最多 100 bytes”；App Store Search 指南写“100 characters total”；每个关键词大于 2 个字符；可本地化 | **是** | [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) 、[App Store search](https://developer.apple.com/app-store/search/) |
| 推广文本（Promotional Text） | 最长 170 个字符；可在不提交新版本的情况下更新 | **否**，Apple 明确说不影响搜索排名 | [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) 、[App Store search](https://developer.apple.com/app-store/search/) |
| 描述（Description） | 最长 4,000 个字符；纯文本，支持换行，不支持 HTML；必填、可本地化 | **Apple 未将其列为 App Store 应用内搜索排名信号**；明确用于发布后的 Web 搜索引擎结果 | [Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information) 、[App Store search](https://developer.apple.com/app-store/search/) |
| 主分类（Primary Category） | 可指定 1 个主分类 | **是**，文本相关性信号；也影响浏览、搜索结果筛选和 Apps/Games 页签归属 | [App Store search](https://developer.apple.com/app-store/search/) 、[Choosing a category](https://developer.apple.com/app-store/categories/) |
| 次分类（Secondary Category） | 可再指定 1 个次分类 | Apple 未将它单独列入搜索文本相关性信号；但分类可帮助用户浏览发现 | [Choosing a category](https://developer.apple.com/app-store/categories/) 、[Discovery on the App Store](https://developer.apple.com/app-store/discoverability/) |

### 关于关键词的 100 字符 / 100 字节差异

Apple 当前两个官方页面的表述不完全一致：

- App Store Search 指南：100 characters total。
- App Store Connect 字段参考：up to 100 bytes of content。

实际填写时应按更严格的 **100 bytes** 预算，并以 App Store Connect 当前输入框的实时计数和校验结果为准。英文 ASCII 字符通常与字节数一致；中文等非 ASCII 字符可能占用多字节，不要只按可见字数预算。

## 关键词填写规则

### Apple 明确建议

1. 选择用户可能用来寻找此类 App 的词，并准确描述功能与特性。[来源：App Store search](https://developer.apple.com/app-store/search/)
2. 关键词之间使用英文逗号分隔，**逗号后不加空格**；只在多词短语内使用空格，例如 `Property,House,Real Estate`。[来源：App Store search](https://developer.apple.com/app-store/search/)
3. 不要重复 App 名称、副标题或分类中已经出现的词。App Store Connect 另说明 App 名称和公司名本身已可搜索，不应再放进关键词。[来源：App Store search](https://developer.apple.com/app-store/search/) 、[Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)
4. 不要同时放入同一词的单数和复数形式，Apple 将其视为重复。[来源：App Store search](https://developer.apple.com/app-store/search/)
5. 避免过于宽泛的词（如 `app`、`game`）、无实际价值的填充词（如 `the`、`to`）。[来源：App Store search](https://developer.apple.com/app-store/search/)
6. 避免 `#`、`@` 等特殊字符，除非它们是品牌识别的一部分。[来源：App Store search](https://developer.apple.com/app-store/search/)
7. 不得放入未授权商标、名人姓名、受保护词语、竞品 App 名称、与 App 无关的词，也不得使用不当或冒犯性词语。关键词不当是常见拒审原因。[来源：App Store search](https://developer.apple.com/app-store/search/)
8. 不得在元数据中堆砌商标、热门 App 名、价格信息或无关短语来操纵发现机制。[来源：App Review Guidelines 2.3.7](https://developer.apple.com/app-store/review/guidelines/)

### 本项目的关键词分配原则

- 名称和副标题优先承载最核心、最能解释产品的搜索意图，如“翻页时钟 / flip clock”。
- 关键词栏用于补足未在名称、副标题和主分类中出现的相关词，例如桌面、横屏、全屏、专注等真实功能或使用场景。
- 中文和英文分别在对应本地化中配置，不要用一串混合语言关键词同时覆盖所有市场。Apple 明确说明，用户可以在 App Store 支持某本地化语言的国家或地区，使用该本地化关键词搜索 App。[来源：Localize app information](https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information)

## 名称与副标题的合规要求

- App 名称应唯一，关键词应准确反映 App；不得藉元数据堆词操纵搜索。[来源：App Review Guidelines 2.3.7](https://developer.apple.com/app-store/review/guidelines/)
- 名称、副标题等元数据不应包含价格、与字段用途不符的条款或描述。[来源：App Review Guidelines 2.3.7](https://developer.apple.com/app-store/review/guidelines/)
- 副标题用于补充说明 App，不应包含不当内容、其他 App 的引用，或无法验证的产品声称，例如“第一”“最佳”“全球领先”。[来源：App Review Guidelines 2.3.7](https://developer.apple.com/app-store/review/guidelines/)
- 元数据必须真实、完整，并与 App 的核心体验保持一致。[来源：App Review Guidelines 2.3](https://developer.apple.com/app-store/review/guidelines/)

## 描述与推广文本的正确用法

### 描述

- 开头先用简短、自然的文字说清楚“这是什么、为谁解决什么问题”。Apple 特别提醒描述首句最重要，因为用户无需展开全文就能看到。[来源：Creating your product page](https://developer.apple.com/app-store/product-page/)
- 后续按真实功能和使用场景展开，让文案自然包含与产品相关的词，供用户阅读和 Web 搜索引擎理解。
- 不使用 HTML，不编造功能，不堆砌与 App 无关的搜索词。
- 如 App 描述或截图中展示需要额外购买的功能，必须明确标示。[来源：App Review Guidelines 2.3.2](https://developer.apple.com/app-store/review/guidelines/)

### 推广文本

- 用于当前新功能、主要价值、季节活动或转化文案，因为它会出现在描述上方且无需提交新版本就能更新。
- 不把它当作关键词栏，因为 Apple 明确说它不影响搜索排名。

## 分类选择

Apple 允许为 App 指定主分类和次分类。主分类对发现尤为重要，因为它：

- 参与 App Store 搜索的文本相关性匹配。
- 决定 App 在分类浏览或搜索结果分类筛选中的位置。
- 决定 iPhone 和 iPad App 归属 Apps 或 Games 页签。

[来源：App Store search](https://developer.apple.com/app-store/search/) 、[来源：Choosing a category](https://developer.apple.com/app-store/categories/)

### Tiqlo Clock 建议

| 项目 | 建议 | 理由 |
| --- | --- | --- |
| 主分类 | Utilities（工具） | Apple 将 clocks、time 明确列为 Utilities 的典型示例，与 Tiqlo Clock 的核心功能最直接匹配。 |
| 次分类 | Productivity（效率） | Apple 将其定义为“使特定流程或任务更有组织、更高效”的 App；可承接专注、学习、办公时钟等次要场景。 |

选择分类时应以 App 的主要功能和用户最可能寻找它的位置为准，不要仅因为某分类流量更大就选择不准确的分类。[来源：Choosing a category](https://developer.apple.com/app-store/categories/)

## 本地化与发现

- 如果某市场没有匹配的本地化，App Store 会按规则使用下一最相关的本地化，最后回退到主要语言。[来源：Localize app information](https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information)
- 本地化关键词可在 App Store 支持该语言的国家或地区中用于搜索 App。[来源：Localize app information](https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information)
- 新增本地化时，截图和多数属性会默认继承主要语言，但描述和关键词不会默认继承，需要单独填写。[来源：Localize app information](https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information)

## 2026 年需关注的 App Tags

Apple 当前会基于 App Store Connect 中提供的元数据、AI 与人工编辑生成 App Tags。这些标签可显示在搜索结果和商品页，用户可点击标签查看相关 App。当前 Apple 说明标签只在美国 App Store 支持和展示，并且默认基于 `en_US` 元数据应用。开发者可在 App Information 中取消不相关标签；取消全部标签可能影响发现。[来源：Manage app tags](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-tags/)

对本项目的含义：英文名称、副标题和描述应准确一致地表达 flip clock、clock、fullscreen、focus 等真实属性，发布后在 App Store Connect 检查自动分配的标签，只保留与产品功能相符的选项。这是基于 Apple 标签机制的实施建议。

## 可直接用于文案检查的清单

- [ ] App 名称为 2–30 个字符，唯一、准确，无竞品名、价格或不可验证声称。
- [ ] 副标题不超过 30 个字符，补充产品用途，不重复名称里的词。
- [ ] 关键词以 App Store Connect 实时计数为准，按最多 100 bytes 做保守预算。
- [ ] 关键词用英文逗号分隔，逗号后不加空格；仅短语内使用空格。
- [ ] 关键词不重复名称、副标题、主分类和公司名中已有的词。
- [ ] 关键词不写单复数变体、宽泛词、填充词、无关词、竞品名和未授权商标。
- [ ] 推广文本不超过 170 个字符，专注于转化，不为搜索堆词。
- [ ] 描述不超过 4,000 个字符，为纯文本，准确说明真实功能。
- [ ] 主分类选择 Utilities（工具），次分类选择 Productivity（效率）。
- [ ] 中文与英文的名称、副标题、关键词、描述分别本地化，不使用机械直译或混合语言堆词。
- [ ] 英文 `en_US` 元数据准确反映核心功能，发布后检查 App Tags 是否相关。

## 官方资料清单

1. [App Store search](https://developer.apple.com/app-store/search/)
2. [Discovery on the App Store and Mac App Store](https://developer.apple.com/app-store/discoverability/)
3. [App Store Connect Help: App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information)
4. [App Store Connect Help: Platform version information](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information)
5. [App Store Connect Help: Localize app information](https://developer.apple.com/help/app-store-connect/manage-app-information/localize-app-information)
6. [Choosing a category](https://developer.apple.com/app-store/categories/)
7. [App Review Guidelines，尤其是 2.3 Accurate Metadata](https://developer.apple.com/app-store/review/guidelines/)
8. [App Store Connect Help: Manage app tags](https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-tags/)
9. [Creating your product page](https://developer.apple.com/app-store/product-page/)
