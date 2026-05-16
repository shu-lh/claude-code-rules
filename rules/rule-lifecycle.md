<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Rule Lifecycle Management [SHOULD]

## 1. Rule Metadata [MUST]

每条规则文件头部必须包含 HTML 注释元数据：

```markdown
<!--
生效日期: YYYY-MM-DD
最后触发: YYYY-MM-DD
适用条件: [always | 仅嵌入式项目 | 仅在包含 FreeRTOS 时 | ...]
过期条件: [none | 当 XXX 时 | YYYY-MM-DD 前有效]
-->
```

Claude 每次引用规则时，更新"最后触发"日期。

## 2. Rule System Self-Audit [MUST]

对规则体系进行定期自检，保持精确、简练、准确：

### 2.1 Quarterly Cleanup [MUST]

每季度第一天（1月1日、4月1日、7月1日、10月1日），会话启动时检查：

**规则文件：**
- 超过 90 天未触发的规则 → 建议删除或归档
- 过期条件已满足的规则 → 建议删除
- 与现有规则冲突的规则 → 建议合并

**Skill 文件（覆盖 `skill-management.md §8.1`）：**
- 超过 90 天未调用的 Skill → 建议废弃
- `deprecated` ≥90 天的 Skill → 建议移除
- 冷却期内无人调用的 Skill → 触发废弃流程

### 2.2 Audit Checklist

自检时逐项排查：

- **矛盾** — 是否存在两条规则对同一场景给出相反指示？
- **过时** — 规则中的参数/引用/假设是否已被代码库或外部环境淘汰？
- **不合理** — 规则约束是否过于严格或过于宽松，导致实际执行困难或无效？
- **冗余** — 是否存在多条规则覆盖同一概念？若有则合并，保留最精确的一条
- **模糊** — 规则描述是否可被不同人不同解读？改为精确、可验证的表述
- **缺失** — 当前实践中反复出现的模式/问题是否需要抽象为新规则？
- **引用断裂** — 规则中 `[Skill: /name]` 引用的 Skill 是否实际存在？Skill 的 `implementation-of` 指向的规则章节是否有效？
- **同步** — 全局和项目 `USER_GUIDE.md` 的最后修改日期是否一致？若不一致，提示用户将全局版本同步到项目

### 2.3 Output

输出清理建议列表，逐条标注问题类型和修改方案，等用户确认后执行。

## 3. `/audit-rules` Skill [MUST]

`/audit-rules` 执行规则和 Skill 体系的完整自检。具体执行流程见 `skills/audit-rules/SKILL.md`。

审计范围包括：
- 规则文件（对照 §2.2 Audit Checklist）
- Skill 文件（对照 `skill-management.md` §8 审计清单）

## 4. New Rule Cooldown [SHOULD]

新增规则先以 [SHOULD] 级别生效 2 周。
2 周后根据实际效果升级为 [MUST] 或降级删除。

## 5. Rule Effectiveness Self-Assessment [SHOULD]

会话结束时，Claude 做简短自评（记录到 state/lessons.md）：
- 本会话是否因规则受益？
- 哪条规则最有帮助？
- 哪条规则造成了阻碍？
