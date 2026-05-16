<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Skill Management [MUST]

管理 `~/.claude/skills/` 下所有 Skill 的完整生命周期：分类、创建、结构标准、注册、审计、废弃。

## 1. Skill vs Rule 区分 [MUST]

### 1.1 核心原则

**Rule = 主动约束**。Rule 文件定义 Claude 在每次对话中**自动遵守**的行为规范。Rule 不需要用户调用，Claude 在行动前自动检查。

**Skill = 被动命令**。Skill 文件定义用户通过 `/命令` 显式调用时 Claude 执行的**操作流程**。Skill 不会被自动触发（除非声明了 trigger 字段）。

### 1.2 决策矩阵

| 用户需求 | 分类为 | 理由 |
|---------|--------|------|
| "让 Claude 记住不要动 vendor code" | Rule | 自动约束，无需用户触发 |
| "帮我添加一个清理临时文件的命令" | Skill | 需要用户显式调用 |
| "每次提交前自动运行测试" | Rule | 自动流程，不应以命令形式存在 |
| "帮我分析上次编译错误的原因" | Skill | 一次性操作，需要交互 |
| 含交互式步骤、需要用户判断 | Skill | Rule 不应包含交互 |
| 含行为约束、自动检查条件 | Rule | Skill 不应定义自动行为 |

### 1.3 混合模式

一条需求可以同时涉及 Rule 和 Skill：

- **Rule 定义"什么条件触发"**，Skill 定义"触发后做什么"
- 示例：freshness.md（Rule）定义">=7天触发"，check-freshness（Skill）定义"触发后执行什么检查"
- 关联方式：Rule 中通过 `[Skill: /skill-name]` 标记指向 Skill

### 1.4 用户请求分类路由

用户要求"添加/修改 X"时，先按 §1.2 决策矩阵判断 X 是 Rule 还是 Skill，然后路由：

```
用户: "添加/修改 X"
  → 分类：Rule 还是 Skill？
    ↓ (Rule)                      ↓ (Skill)
  → rule-change.md §6 放置逻辑    → §5 生命周期（创建/修改）
  → rule-change.md §7 扩展优先    → §3 格式标准
  → rule-change.md §8 排序维护    → §6 注册要求
```

### 1.5 边界情况

- **触发器 Skill**：如果 Skill 声明了 `trigger` 字段（如 `/audit-rules`），它仍属于 Skill —— trigger 只是匹配用户特定输入，本质仍是用户显式触发
- **纯自动化流程**：如果某个行为永远不需要用户参与（如会话启动时自动检查），应该写在 Rule 中而非 Skill 中

## 2. Skill 目录结构 [MUST]

### 2.1 标准布局

```
~/.claude/skills/
  ├── <skill-name>/            # kebab-case 目录名
  │   └── SKILL.md             # 技能定义文件（唯一必需文件）
```

### 2.2 单一文件原则 [MUST]

Skill 的所有核心定义在 `SKILL.md` 中。不拆分到多个文件中。不需要辅助工具脚本（Skill 本身就是 step-by-step 指令，Claude 直接执行）。

## 3. SKILL.md 标准格式 [MUST]

### 3.1 Frontmatter 字段

```yaml
---
name: <skill-name>
description: "<一句话描述，≤120 字符，用户可见>"
argument-hint: "[light|full]"       # 可选：参数提示
user-invocable: true                # 是否可通过 /name 调用
allowed-tools:                      # 最小必要工具集（见 §7）
  - Read
  - Glob
trigger: "/command-name"            # 可选：匹配用户输入的触发器
implementation-of:                  # 可选：实现了哪些规则
  - rules/freshness.md §2
---
```

**字段说明**：

| 字段 | 必填 | 说明 |
|------|------|------|
| `name` | MUST | 与目录名一致，kebab-case |
| `description` | MUST | 用户可见的简短描述，出现在 `/skills` 列表和 CLAUDE.md 表格中 |
| `argument-hint` | SHOULD | 如果 Skill 接受参数，必须提供 |
| `user-invocable` | MUST | 是否可通过 `/name` 调用 |
| `allowed-tools` | MUST | Skill 执行所需的最小工具集 |
| `trigger` | SHOULD | 用户输入匹配模式 |
| `implementation-of` | SHOULD | 此 Skill 实现了哪些规则的哪些章节 |

### 3.2 Body 结构

Frontmatter 后跟 Markdown 正文，推荐结构：

```markdown
# <Skill Name>

<1-2 句概述：做什么，何时用>

## Parameters

<如果有参数，在此定义各参数的语义和默认行为>

## Execution

### Step 1: <步骤名>
<详细指令>

### Step 2: <步骤名>
<详细指令>

## Constraints

<执行中的约束：token 预算、不允许的操作、超时处理等>
```

### 3.3 质量标准

一份合格的 `SKILL.md` 必须满足：

- [ ] Frontmatter：name, description, user-invocable, allowed-tools 四项齐全
- [ ] 描述：用户可以在 3 秒内理解此 Skill 的作用
- [ ] 参数：如果接受参数，每个参数有明确语义和默认值
- [ ] 步骤：Execution 步骤可被 Claude 逐字执行，没有"酌情处理"的模糊指令
- [ ] 约束：有明确的 token 预算、不允许的操作、停止条件
- [ ] 引用：指向相关的规则文件章节

### 3.4 反模式

| 反模式 | 示例 | 正确做法 |
|--------|------|---------|
| 无步骤 | "根据情况处理" | 列出具体的验证和执行步骤 |
| 万能工具 | allowed-tools 写满所有工具 | 仅声明步骤实际使用的工具 |
| 免责描述 | "尝试检查" | "检查 A、B、C 三项" |
| 无限执行 | "一直检查直到通过" | "最多重试 3 次" |
| 推理替代指令 | "Claude 自己判断怎么做" | 给出明确的判断条件和分支路径 |

## 4. 命名规范 [MUST]

| 实体 | 规范 | 示例 |
|------|------|------|
| Skill 名称 | kebab-case，全小写字母 + 连字符 | `check-freshness` |
| 目录名 | 与 skill 名称完全一致 | `skills/check-freshness/` |
| Skill 文件 | 固定为 `SKILL.md`，大小写敏感 | `SKILL.md` |
| 命令名 | 用户输入为 `/skill-name` | `/check-freshness` |

**禁止**：驼峰命名、下划线、目录名与 `name` 字段不一致。

## 5. Skill 生命周期 [MUST]

```
创建 → 审查 → 冷却 → 成熟 → 废弃 → 移除
```

### 5.1 创建 (Creation)

触发条件：
- 用户要求"添加一个 /xxx 命令"
- Claude 发现重复 3 次以上的手动操作模式，建议创建 Skill
- 现有 Rule 中包含交互式流程（应提取为 Skill）

创建步骤：
1. 按 §3 标准创建 `~/.claude/skills/<name>/SKILL.md`
2. 初始 `allowed-tools` 设置为最小保守集（宁缺勿滥，可后续加）
3. 按 §6 注册到 CLAUDE.md 和 USER_GUIDE.md
4. 在 `state/rule-changelog.md` 记录：`[ADD] skill/<name> — 用途简述`

### 5.2 审查 (Review) [MUST]

Skill 创建或每次修改后，Claude 自动检查：

- 所有 `allowed-tools` 是否被 body 中的步骤实际使用？（未使用的工具 → 移除）
- Body 中是否存在步骤使用了未声明的工具？（遗漏的工具 → 补充）
- `description` 是否 ≤120 字符且清晰可理解？
- Execution steps 是否可被 Claude 逐行执行？
- 如果声明了 `argument-hint`，body 中是否包含参数校验步骤？（缺失 → 建议补充）

### 5.2.1 参数校验行为 [MUST]

Skill 收到不符合 `argument-hint` 的参数时：
1. 输出使用提示："用法：`/<skill-name> <参数格式>`"
2. 不执行任何业务步骤
3. 不等同于默认参数——参数格式错误时不猜测用户意图

未声明 `argument-hint` 的 Skill 收到参数时，应忽略参数继续执行。

### 5.3 冷却 (Cooldown) [SHOULD]

新创建的 Skill 标记为 `[EXPERIMENTAL]` 状态，持续 2 周：

- 冷却期内 Claude 在调用时输出 `[EXPERIMENTAL] 此 Skill 尚在冷却期` 提示
- 2 周后自动转为 `[STABLE]`
- 如果冷却期内无人调用，触发 §5.5 废弃流程

### 5.4 成熟 (Mature) [SHOULD]

Skill 转为 `[STABLE]` 的条件：
- 冷却期 ≥2 周
- 被成功调用 ≥3 次
- 审查检查全部通过

### 5.5 废弃 (Deprecation) [MUST]

触发条件：
- Skill 超过 90 天未被调用
- 被新 Skill 取代（显式声明 `replaced-by: <new-skill>`）
- 依赖的外部工具/API 已不可用

处理方式：
1. 在 `SKILL.md` frontmatter 中添加 `deprecated: true` 和 `deprecation-reason: "<原因>"`
2. 保持文件存在，CLAUDE.md 和 USER_GUIDE.md 中标注`（已废弃）`
3. 用户调用时响应："此 Skill 已废弃，原因：<原因>。建议使用 <替代方案>。"

### 5.6 移除 (Removal) [MUST]

废弃满 90 天后可移除：
1. 删除 `~/.claude/skills/<name>/` 目录
2. 从 CLAUDE.md 和 USER_GUIDE.md 表格中删除对应行
3. 在 `state/rule-changelog.md` 记录：`[REMOVE] skill/<name> — 原因`

## 6. 注册要求 [MUST]

### 6.1 CLAUDE.md Skills 表格

新增或删除 Skill 时，必须更新 `~/.claude/CLAUDE.md` Skills 表格。
修改 checklist：
- [ ] 表格新增一行（创建时）
- [ ] 表格删除一行（移除时）
- [ ] 描述更新（description 变更时）
- [ ] 参数提示更新（argument-hint 变更时）

### 6.2 USER_GUIDE.md 命令速查表

新增或删除 Skill 时，必须同步更新 `~/.claude/USER_GUIDE.md` 命令速查表。
修改 checklist：
- [ ] 表格新增一行
- [ ] 表格删除一行
- [ ] 废弃标注

### 6.3 级联同步

如果存在项目级别的 `.claude/USER_GUIDE.md`（通过 `init-project-rules` 生成），全局 `USER_GUIDE.md` 的 Skill 变更必须同步到所有项目的副本。列出受影响的项目路径，等待用户确认后同步。

## 7. Allowed-Tools 最小权限原则 [MUST]

### 7.1 核心原则

Skill 的 `allowed-tools` 只包含执行该 Skill 步骤**实际需要**的工具，不包含"可能有用"的工具。

### 7.2 工具选择参考

| 任务类型 | 应声明 | 不应声明 |
|---------|--------|---------|
| 只读分析 | Read, Glob, Grep | Write, Edit, Bash, WebSearch |
| 联网查询 | WebSearch, WebFetch, Read | Write, Edit, Bash |
| 创建文件 | Read, Glob, Grep, Write, Edit, Bash | WebSearch, WebFetch |
| 修改规则 | Read, Glob, Grep, Edit | WebSearch, WebFetch, Write |

### 7.3 审查时机

创建 Skill 时按 §5.2 自动审查；修改 execution 步骤时重新审查；季度审计时统一检查。

## 8. Skill 审计 [MUST]

Skill 审计是 `/audit-rules` 的一部分。审计 `~/.claude/skills/` 时逐项检查：

| 检查项 | 标准 | 违规处理 |
|--------|------|---------|
| **孤儿 Skill** | SKILL.md 存在但未出现在 CLAUDE.md 表格中 | 建议注册或删除 |
| **死 Skill** | 超过 90 天未调用 | 建议废弃 |
| **描述模糊** | description 未能让用户理解何时调用 | 建议重写 |
| **工具泄漏** | allowed-tools 中有未被使用的工具 | 建议移除 |
| **工具缺失** | body 中使用了未声明的工具 | 建议补充 |
| **命名不一致** | 目录名 != frontmatter name | 建议重命名 |
| **缺少步骤** | body 中没有可执行的步骤 | 建议补充 |
| **注册过时** | CLAUDE.md 或 USER_GUIDE.md 引用不一致 | 建议同步 |
| **引用断裂** | 规则文件中 `[Skill: /name]` 引用了不存在的 Skill；或 Skill 的 `implementation-of` 指向了无效的规则章节 | 建议修复引用或创建缺失文件 |
| **废弃未清理** | deprecated >=90 天仍存在 | 建议移除 |

审计报告格式：

```
[SKILL-AUDIT]
  ~/.claude/skills/:
    ✓ check-freshness — 全部合格
    ✗ audit-rules — 缺少 allowed-tools 声明

  是否修复？(yes/no/edit)
```

### 8.1 季度自动检查

季度清理由 `rule-lifecycle.md §2.1` 统一触发（规则 + Skill），覆盖范围见 §8 审计清单。

## 9. Skill 与 Rule 的引用关系 [SHOULD]

### 9.1 Skill 引用 Rule

Skill 在 `implementation-of` 字段中声明它实现了哪些规则：

```yaml
implementation-of:
  - rules/freshness.md §2
```

这有助于审计时定位规则是否被正确实现，以及规则变更时同步更新 Skill。

### 9.2 Rule 引用 Skill

Rule 文件在需要用户交互的步骤中引用 Skill：

```markdown
## 3. Parameter Validation

建议用户运行 `/check-freshness` 执行完整检查
[Skill: /check-freshness]
```

引用格式：`[Skill: /skill-name]`

### 9.3 引用的自动维护

- 创建 Skill 时，检查 `implementation-of` 声明的规则是否存在、章节号是否有效
- 修改规则时，检查是否有 Skill 的 `implementation-of` 指向被修改章节，若有 → 输出 [CASCADE] 提示
- 读取所有规则文件，提取 `[Skill: /name]` 引用，验证对应 SKILL.md 是否存在 → 不存在则输出 [CASCADE] 提示
