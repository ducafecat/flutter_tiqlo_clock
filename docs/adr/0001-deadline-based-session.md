# 显示时间由源计算，不靠每秒加减

Clock 的时分秒从墙上 now 派生。Session 的剩余时间从单调 elapsed 派生。都不在内存里每秒 +1 / −1。Pause 存 remaining，Resume 换新的计时原点。

被否决的方案是独立 ticker 累加或倒扣。Session 用墙上 DateTime deadline 的部分由 ADR 0009 取代。
