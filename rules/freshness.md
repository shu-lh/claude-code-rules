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

## 2. Check Items

### 2.1 Prompt Cache TTL [MUST]
- 当前值：~5 分钟
- 检查方式：WebSearch "Anthropic prompt cache TTL"
- 变化超 30% → 通知用户并更新 efficiency.md

### 2.2 Claude Code Tools [SHOULD]
- 检查方式：WebSearch "Claude Code new tools"
- 新工具 → 评估是否加入 tool-selection.md
- 废弃工具 → 从矩阵移除

### 2.3 VSCode Extension Config [SHOULD]
- 检查方式：WebSearch "Claude Code VSCode extension changelog"
- 关注：权限模型变化、settings.json schema、新 hook 事件
- 有变化 → 建议更新 settings.json

### 2.4 Available Models [MUST]
- 检查方式：WebSearch 当前可用模型及参数
- 收集：模型名、上下文窗口、适用场景
- 参数变化超 20% → 更新 model-routing.md

### 2.5 Other Time-Sensitive Parameters [SHOULD]
- 工具链版本（ARM GCC、CMake、Ninja）
- FreeRTOS 最新版本
- OpenOCD 版本

## 3. Check Strategy [MUST]

- 轻度检查：2.1 + 2.4，各 1 次 WebSearch，预算 ≤2000 tokens
- 完整检查：全部 5 项，每项 ≤2 次 WebSearch，预算 ≤8000 tokens
- 超预算 → 中断，记录到 freshness.json，下次续查
- 所有结果以 `[FRESHNESS-REPORT]` 格式输出，等用户确认后更新

## 4. State Format

```json
{
  "lastCheck": "2026-05-17",
  "nextCheck": "2026-05-24",
  "checks": {
    "promptCacheTTL": { "lastChecked": "...", "currentValue": "5 minutes", "status": "valid" },
    "models": { "lastChecked": "...", "available": [], "status": "valid" },
    "tools": { "lastChecked": "...", "status": "valid" },
    "vscodeExtension": { "lastChecked": "...", "status": "valid" },
    "toolchains": { "lastChecked": "...", "status": "valid" }
  }
}
```
