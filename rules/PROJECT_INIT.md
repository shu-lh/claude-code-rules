<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Project Initialization Flow

当 Claude 进入一个没有 CLAUDE.md 或 .claude/ 的项目时，按此流程初始化。

## 1. Detection

进入新项目目录时，检查：
- 是否存在 `CLAUDE.md` 或 `.claude/`？
- 是否存在 `README.md`、`Docs/`、`ARCHITECTURE.md` 等说明文档？

若都不存在 → 提示用户运行 `/init-project-rules`。

## 2. Execution

用户确认后，按 `[Skill: /init-project-rules]` 中的步骤执行分析、生成和确认。

## 3. On Existing Projects

如果项目已有 CLAUDE.md → 只建议补充，不覆盖。
如果项目已有 .claude/rules/ → 只建议补充缺失的规则。
