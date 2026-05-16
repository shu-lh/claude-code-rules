<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Documentation Sync [MUST]

## 1. Trigger Conditions [MUST]

以下变更完成后，MUST 检查并更新相关说明文件。文件映射以项目 `docs-sync-map.md` 为准（无 docs-sync-map.md 的项目按通用默认处理）。

| 变更类型 | 说明 |
|---------|------|
| 架构变更 | 新增/删除模块、改变分层 → 更新架构文档 + .claude/rules/ |
| API/接口变更 | 函数签名、抽象接口变化 → 更新相关文档 + CLAUDE.md |
| 硬约束变更 | 任务周期、内存、外设配置 → 更新 .claude/rules/ 对应约束 |
| 构建系统变更 | 源文件/编译选项 → 更新构建文档 |
| 硬件/外设变更 | 引脚、外设配置 → 更新硬件文档 + .claude/rules/ |
| 命令接口变更 | 新增/删除 CLI 命令 → 更新接口文档 |
| Skill 变更 | 新增/删除 skill → 更新 `~/.claude/USER_GUIDE.md`（详见 `skill-management.md` §6）|
| USER_GUIDE 同步 | 全局 USER_GUIDE.md 更新 → 同步到项目 `.claude/USER_GUIDE.md` |

## 2. Update Strategy [MUST]

- 架构/接口变更 → 更新项目架构文档和 CLAUDE.md 架构段
- 硬约束变更 → 更新 .claude/rules/*.md 中的具体数值
- 全局 USER_GUIDE.md 变更 → 同步到所有项目 `.claude/USER_GUIDE.md`
- 小改动不更新文档（bugfix、日志调整、不改变接口的内部重构）

## 3. Stale Info Detection [SHOULD]

修改代码时，如果发现注释、文档与当前代码不一致：
- 以代码为准更新文档
- 如果差异可疑（可能是未完成功能），先向用户确认

## 4. Project Instantiation

在项目规则中需明确指定：
- 哪些文档需要维护（列出具体路径）
- 哪些路径是 generated code（禁止手动修改）
- 使用 docs-sync-map.md 定义精确的代码→文档映射
