---
name: check-freshness
description: 检查全局规则中的时效性参数是否过时，联网验证并更新。轻度检查(cache TTL + models)，完整检查(含工具/VSCode配置/工具链版本)。
argument-hint: "[light|full]"
user-invocable: true
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Edit
  - Write
---

# Check Freshness Skill

验证 `~/.claude/rules/` 中时效性参数是否仍准确。

## Parameters

- 无参数 → 根据距上次检查天数自动选择 light/full
- `light` → 只查 cache TTL + models（~2000 tokens）
- `full` → 全部 5 项（~8000 tokens）

## Execution

### Step 1: Read State

读取 `~/.claude/state/freshness.json`。若无 → 视为首次运行，执行 full。

### Step 2: Execute Checks

按 `~/.claude/rules/freshness.md` §2 定义的 5 项逐项检查。

每完成一项，向用户报告进度。

### Step 3: Generate Report

以固定格式输出：

```
[FRESHNESS-REPORT]
  ✓ <item> : <current>，无变化
  ▲ <item> : <old> → <new>，建议更新 <file>
  ✗ <item> : 检查失败，<reason>

是否更新？(yes/edit: 选择部分更新)
```

### Step 4: Apply Updates

根据用户确认，用 Edit 更新对应规则文件中的参数值，更新 freshness.json。

## Token Budget

- light: ≤2000 tokens
- full: ≤8000 tokens
- 超预算立即停止，记录到 freshness.json，下次续查
