---
name: check-freshness
description: 检查全局规则中的时效性参数是否过时，联网验证并更新。轻度检查(cache TTL + models)，完整检查(含工具/VSCode配置/工具链版本)。
argument-hint: "[light|full]"
user-invocable: true
status: experimental
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

收到不符合 `[light|full]` 的参数时，输出使用提示并不执行任何检查步骤。

## Execution

### Step 1: Read State

读取 `~/.claude/state/freshness.json`。若无 → 视为首次运行，执行 full。

### Step 2: Scan Parameters

扫描所有生效规则文件（`~/.claude/rules/` + 项目 `.claude/rules/`），提取时效性参数：
- 版本号引用（如 `GCC 14.2.rel1`、`FreeRTOS V11.1.0`）
- 模型名引用（如 `Claude Opus 4.7`）
- 工具名引用（如 `CMake`、`Ninja`、`OpenOCD`）
- 时间/日期引用（如 `2026-05-17`、`~5 分钟`）
- 外部 URL 或服务名

### Step 3: Read Environment Config

- 从 `settings.json` 中提取模型环境变量（`ANTHROPIC_MODEL`、`ANTHROPIC_DEFAULT_OPUS_MODEL` 等实际值）
- 从项目构建文件（`CMakeLists.txt`、`Board/*.cmake`）提取工具链版本
- 从项目配置文件（`FreeRTOSConfig.h` 等）提取中间件版本

### Step 4: Compile Check List

将 Step 2 + Step 3 提取的参数去重后，按领域归类为检查项。
每个检查项需说明：
- 来源规则文件（哪条规则引用了此参数）
- 当前值
- 验证方式（搜索关键词或命令）
- 变化阈值（如有明确数值则可设置 % 阈值）

### Step 5: Execute Checks

按编译后的检查清单逐项验证，每完成一项向用户报告进度。

### Step 6: Generate Report

以固定格式输出：

```
[FRESHNESS-REPORT]
  ✓ <item> : <current>，无变化
  ▲ <item> : <old> → <new>，建议更新 <file>
  ✗ <item> : 检查失败，<reason>

是否更新？(yes/edit: 选择部分更新)
```

### Step 7: Apply Updates

根据用户确认，用 Edit 更新对应规则文件中的参数值，更新 freshness.json。

## Token Budget

- light: ≤2000 tokens
- full: ≤8000 tokens
- 超预算立即停止，记录到 freshness.json，下次续查
