---
name: audit-rules
description: Self-audit the rule system — check for contradictions, outdated entries, redundancy, vagueness, and missing coverage across all active rules
trigger: /audit-rules
user-invocable: true
status: experimental
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
implementation-of:
  - rules/rule-lifecycle.md §2.2
  - rules/rule-lifecycle.md §3
  - rules/skill-management.md §8
---

# /audit-rules — Rule System Self-Audit

## Behavior

Scans all active rule files (global + project) and reports issues:

1. **Scan** — collect all `.md` files from `~/.claude/rules/` and project `.claude/rules/`
2. **Audit** — evaluate each file against the checklist in [rule-lifecycle.md §2.2](/rules/rule-lifecycle.md)
3. **Report** — output findings grouped by type:
   - **矛盾** — conflicting instructions for the same scenario
   - **过时** — stale parameters/references
   - **不合理** — overly strict or loose constraints
   - **冗余** — multiple rules covering the same concept
   - **模糊** — imprecise or ambiguous wording
   - **缺失** — recurring patterns not yet captured as rules
4. **Confirm** — ask user whether to apply fixes, do not modify without approval
5. **Execute** — apply changes across all affected files after confirmation

## Constraints

- Token budget: ≤12000 tokens
- 不在无用户确认的情况下修改任何文件
- 发现无法读取的文件 → 跳过并报告
- 遇到 404/缺失文件时继续执行，不中断审计

## When to Use

- Periodically (supplements automatic quarterly checks)
- After making significant changes to the rule system
- When you suspect rules may be conflicting or stale
