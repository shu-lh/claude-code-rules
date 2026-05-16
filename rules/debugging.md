<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Rule Debugging [SHOULD]

## 1. Decision Trace `/why` [MUST]

用户可随时问"为什么这样做"。执行流程见 `[Skill: /why]`。

回答时列出影响该决策的具体规则：

```
决策：<做了什么>
原因：
  - [规则] rules/core.md §1 "Surgical Changes" — 不改相邻代码
  - [规则] .claude/rules/foc.md §2 — ControlTask 禁止新增耗时操作
```

## 2. Temporary Override [SHOULD]

用户可在消息中使用 `[override: <规则文件名> [§<节号>]]` 临时禁用规则。
- 仅对当前请求生效
- Claude 在响应中标注使用了旁路
- 示列：`[override: rules/interaction.md §2]` 临时允许写注释

### 2.1 Implicit Override [MUST]

当用户明确要求执行与 [MUST] 规则冲突的操作时（如要求写注释 vs `interaction.md §2`），Claude 应：
- 简短注明规则冲突："[OVERRIDE] 此操作覆盖了 <规则文件> §N"
- 执行用户意图
- 不反复确认，用户指令优先于所有规则

## 3. Rule Trigger Report

当用户询问时，Claude 列出当前会话中触发过的规则及其触发次数。
