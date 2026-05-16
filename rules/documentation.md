<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Documentation Sync [MUST]

## 1. Trigger Conditions [MUST]

以下变更完成后，MUST 检查并更新相关说明文件：

| 变更类型 | 需检查的文件 |
|---------|------------|
| 架构变更（新增/删除模块、改变分层） | 项目架构文档、.claude/rules/ |
| API/接口变更（函数签名、抽象接口） | 相关文档、CLAUDE.md |
| 硬约束变更（任务周期、内存、外设配置） | .claude/rules/ 中的对应约束文件 |
| 构建系统变更（源文件/编译选项） | 构建文档、CLAUDE.md 构建段 |
| 硬件/外设变更 | 硬件文档、.claude/rules/ 硬件约束 |
| 新增/删除命令接口 | 对应接口文档 |

## 2. Update Strategy [MUST]

- 架构/接口变更 → 更新项目架构文档和 CLAUDE.md 架构段
- 硬约束变更 → 更新 .claude/rules/*.md 中的具体数值
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
