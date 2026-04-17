# Anti-Hallucination Rules (需求感知层强制约束)

**适用范围**: 所有需求感知层 Skills 和 Subagent 在执行市场/竞品/用户/数据相关分析时必须遵守。

## 核心规则

### 1. 强制搜索先行

**在执行分析前，必须先使用 WebSearch 或 WebReader 获取最新信息。**

- 禁止仅凭训练记忆输出任何具体数据（市场规模、增长率、功能列表、用户数据等）
- 每个数据点必须来自实际搜索和访问的页面
- 搜索查询应包含年份，例如 `Gartner SaaS market size 2025 2026`

### 2. 每个声明必须有来源

**每个具体数据点必须附带可验证的 URL 来源。**

- 市场规模数字 → 必须有来源 URL
- 竞品功能声明 → 必须有官网/文档 URL
- 用户引用 → 必须有访谈记录或公开来源 URL
- 趋势判断 → 必须有报告或新闻 URL
- **没有来源 = 不得写入**

来源格式：
```json
{
  "claim": "SaaS 项目管理市场规模 2025 年约 80 亿美元",
  "source": "https://www.grandviewresearch.com/...",
  "source_name": "Grand View Research",
  "fetched_at": "2026-04-17T10:30:00Z"
}
```

### 3. 未知即标注未知

**如果通过搜索无法找到可靠数据，明确标注 "Unknown" 或 "需要进一步调研"。**

- 不要编造数字填补空白
- 标注未知不是失败，是诚实
- 可以在 Recommendations 中指出 "需要人工调研此数据"

示例：
```json
{
  "market_size": {
    "tam": "Unknown — 未找到该细分市场的权威规模数据",
    "growth_rate": "12% CAGR",
    "growth_rate_source": { "url": "...", "source_name": "Statista" }
  }
}
```

### 4. 置信度评级

**每个关键数据点必须标注 confidence 等级。**

| 等级 | 要求 | 示例来源 |
|:---|:---|:---|
| `high` | 权威来源（Gartner, Forrester, IDC, 官方财报, Crunchbase） | Gartner Magic Quadrant 数据 |
| `medium` | 可靠来源（TechCrunch, Statista, 行业报告, 竞品官网功能页） | 竞品官网 Pricing 页面 |
| `low` | 社区讨论、博客、推测性分析，或数据已过时 | Reddit 讨论、个人博客 |

### 5. 区分事实与推断

**严格区分已验证事实和基于事实的推断。**

```json
{
  "facts": [
    {
      "claim": "Notion AI 功能于 2023 年 3 月上线",
      "source": "https://www.notion.so/blog/...",
      "confidence": "high"
    }
  ],
  "inferences": [
    {
      "claim": "Notion AI 可能主要面向知识工作者",
      "basis": "基于产品定位和功能的推断",
      "confidence": "medium"
    }
  ]
}
```

### 6. 质量门槛（不可妥协）

**以下任一条未满足，不得输出结果：**

- [ ] 所有具体数字/功能/趋势声明都有来源 URL
- [ ] 无法验证的数据已标注 "Unknown"
- [ ] 每个数据点标注了 confidence 等级
- [ ] facts 和 inferences 已明确区分
- [ ] 搜索记录已附在输出中（证明确实执行了搜索）

## 搜索记录

每个分析输出必须附带搜索记录：

```json
{
  "search_queries_used": [
    "SaaS project management market size 2025 2026",
    "Gartner project management software magic quadrant 2025"
  ],
  "sources_accessed": [
    { "url": "...", "title": "...", "used_for": "market size data" }
  ]
}
```
