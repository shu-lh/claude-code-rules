<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Rule Freshness Check [MUST]

规则中的参数可能随时间过时。需定期验证关键参数。

## 1. Trigger Timing [MUST]

| 触发条件 | 行为 |
|---------|------|
| 距上次检查 ≥ 7 天 | 会话启动时自动执行轻度检查 |
| 距上次检查 ≥ 30 天 | 会话启动时自动执行完整检查 |
| 用户调用 `/check-freshness` | 执行完整检查 |
| 用户提到"最新""现在""目前"等时间词 | 对相关参数执行即时检查 |

状态存储在 `~/.claude/state/freshness.json`。

## 2. Check Items [MUST]

检查项**不硬编码**，每次执行时通过扫描规则体系和环境配置动态发现时效性参数。具体扫描步骤见 `[Skill: /check-freshness]`。

可能的检查项示例（取决于当前规则内容）：

| 来源 | 参数 | 验证方式 |
|------|------|---------|
| efficiency.md §1 | Prompt Cache TTL | WebSearch "Anthropic prompt cache TTL" |
| settings.json | `deepseek-v4-pro[1m]` | WebSearch "deepseek-v4-pro model" |
| settings.json | `deepseek-v4-flash` | WebSearch "deepseek-v4-flash" |
| foc.md §1 | ControlTask 100μs | 无需验证（业务逻辑不变）|
| foc.md §2 | FreeRTOS V11.1.0 | WebSearch "FreeRTOS latest version" |
| Board/*.cmake | ARM GCC 14.2.rel1 | WebSearch "ARM GCC latest version" |
| model-routing.md | 模型路由规则 | WebSearch 当前可用模型 |

## 3. Check Strategy [MUST]

- 轻度检查：仅 check prompt cache TTL（来源：efficiency.md §1），预算 ≤2000 tokens
- 完整检查：扫描全部规则 + 环境配置 + 项目工具链，逐项验证，预算 ≤8000 tokens
- 超预算 → 中断，在 freshness.json 中标记未完成的检查项，下次续查
- 执行流程详见 `[Skill: /check-freshness]`

## 4. State Format

动态检查项的 `checks` 字段为可变 Key-Value 结构，key 为检查项标识符：

```json
{
  "lastCheck": "2026-05-17",
  "nextCheck": "2026-05-24",
  "checks": {
    "promptCacheTTL": { "lastChecked": "2026-05-17", "currentValue": "5 minutes", "status": "valid" },
    "deepseek-v4-pro[1m]": { "lastChecked": "2026-05-17", "currentValue": "v4-pro", "status": "valid" },
    "deepseek-v4-flash": { "lastChecked": "2026-05-17", "currentValue": "v4-flash", "status": "valid" },
    "armGcc": { "lastChecked": "2026-05-17", "currentValue": "14.2.rel1", "latest": "14.3.rel1", "status": "outdated" },
    "freertos": { "lastChecked": "2026-05-17", "currentValue": "V11.1.0", "latest": "V11.2.0", "status": "outdated" }
  },
  "pendingItems": []
}
```

每次检查完成后更新对应条目的 `status`、`currentValue`、`lastChecked`。未完成的检查项列入 `pendingItems`。
