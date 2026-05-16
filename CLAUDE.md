# Claude Code — Global Configuration

> Last updated: 2026-05-17

## Session Startup

每次会话启动：
1. 确认运行环境（操作系统、AI 对话环境、项目上下文）
2. 读取 `state/freshness.json` 检查是否需时效刷新
3. 读取 `state/lessons.md` 加载历史错题，检查是否有影响当前任务的教训需应用
4. 检查当日是否为季度首日（1/1, 4/1, 7/1, 10/1）→ 执行规则+Skill 季度清理（详见 `rule-lifecycle.md §2.1`）

## Rules Index

按重要性排序。冲突时：项目规则 > 全局规则 > 系统默认。

### Foundation (always active)
/rules/core.md           — Core engineering discipline [MUST]
/rules/interaction.md    — Interaction style [MUST]
/rules/efficiency.md     — Token/cache efficiency [MUST]
/rules/tool-selection.md — Tool selection priority [MUST]
/rules/model-routing.md  — Model auto-routing [MUST]

### Meta-Rules
/rules/rule-change.md    — Rule change notification [MUST]
/rules/documentation.md  — Documentation sync [MUST]
/rules/rule-lifecycle.md — Rule lifecycle management [SHOULD]
/rules/skill-management.md — Skill lifecycle management [MUST]
/rules/debugging.md      — Rule debugging & /why [SHOULD]
/rules/freshness.md      — Rule freshness check [MUST]

### Domain-Specific
/rules/git.md            — Git workflow [SHOULD]
/rules/embedded/constraints.md — Embedded hard constraints [MUST]
/rules/embedded/cpp.md         — Embedded C++ conventions [SHOULD]

### Project Initialization
/rules/PROJECT_INIT.md   — New project onboarding flow

## Skills

| Skill | Description |
|-------|-------------|
| `/check-freshness [light\|full]` | Verify rule parameters are current |
| `/init-project-rules` | Auto-generate project rules from analysis |
| `/why` | Trace rule basis for Claude's decisions |
| `/audit-rules` | Self-audit rule system: check for contradictions, outdated entries, redundancy, vagueness, and missing coverage across all active rules |
