---
name: why
description: 追溯 Claude 最近决策的规则依据，列出影响特定行为的具体规则
user-invocable: true
status: experimental
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Why Skill

解释 Claude 为什么做出某个决策，追溯到哪条规则驱动了该行为。

## Execution

### When invoked with no args

列出当前会话中最近触发的规则（最近 5 次决策）。

### When invoked with a question

如 "/why 你没修改那个文件？"

Claude 回答时列出影响该决策的规则：

```
决策：<做了什么>
原因：
  - [规则] rules/core.md §1 "Surgical Changes" — 不改相邻代码
  - [规则] rules/embedded/constraints.md §5 — Firmware/ 目录禁止修改
```

### When invoked with `--all`

列出当前会话中所有被触发过的规则及其触发次数。
