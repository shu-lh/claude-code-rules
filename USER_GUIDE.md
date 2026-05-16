# Claude Code 规则系统 — 用户指南

> 最后修改: 2026-05-17

## 它是什么

这是一套两级规则系统，让 Claude Code 自动遵守你的工作规范：

```
~/.claude/   ← 全局规则（所有项目通用）
  ├── rules/        # 行为约束
  ├── skills/       # 可调用的技能
  └── state/        # 运行时数据

你的项目/CLAUDE.md + .claude/   ← 项目规则（项目特化约束）
```

## 核心理念

**你只管描述"要做什么"，系统自动处理"怎么做"**。

规则像交通标志——Claude 在行动前自动检查适用的规则，不需要你每次提醒。

## 快速上手

### 首次安装

全局规则已创建在 `~/.claude/` 下。在任意项目中启动 Claude Code 时自动生效。

### 日常使用

启动后 Claude 自动加载规则。你只需像往常一样下达任务：

| 你想达到的效果 | 已自动生效（无需提醒） |
|--------------|-------------------|
| Claude 不写多余注释 | interaction.md 已设定 |
| Claude 只改目标代码 | core.md §Surgical Changes 已设定 |
| 复杂任务先出方案 | Claude 自动判断复杂度，复杂则进入 Plan 模式 |
| 修改后自动更新文档 | Claude 检查 docs-sync-map.md |
| 简单任务不浪费 pro 额度 | Claude 评估复杂度，简单用 flash 模型 |
| 选最高效的工具 | tool-selection.md 优先级矩阵 |

### 需要你参与的

| 场景 | 你会看到 | 你做什么 |
|------|---------|---------|
| 复杂度高的任务 | `[MODEL]` 建议切换到 pro 模型 | 回复 yes/no |
| 规则需要变更 | `[RULE-CHANGE]` 建议变更某文件 | 回复 yes/no/edit |
| 时效参数过时 | `[FRESHNESS]` cache TTL 变了 | 回复 yes 确认更新 |
| Claude 行为不符合预期 | 问 "为什么这样做" | Claude 列出影响的规则 |
| 安全敏感操作 | "此操作涉及硬件安全，请确认" | 阅读风险说明后确认 |
| Claude 犯了错 | 描述错误 | Claude 建议更新规则防止再犯 |

## 命令速查

| 命令 | 作用 | 何时用 |
|------|------|--------|
| `/audit-rules` | Self-audit rule system for contradictions, redundancy, vagueness | 怀疑规则冲突/过时；大幅修改规则后 |
| `/check-freshness` | 检查规则参数是否过时 | 首次使用；每隔几周 |
| `/check-freshness full` | 完整检查（含工具链版本） | 每月一次 |
| `/why` | 解释 Claude 为什么这样决策 | 行为不符合预期时 |
| `/init-project-rules` | 为新项目自动生成规则 | 新项目首次使用 Claude |
| `/clear` | 清空对话，保留规则 | 任务完成后开始新任务 |

## 工作原理

### 规则加载流程

```
启动 Claude Code
      │
      ▼
加载 ~/.claude/CLAUDE.md（全局入口）
      ├──→ rules/*.md 自动读取
      ├──→ state/freshness.json 检查时效
      └──→ state/lessons.md 加载错题
      │
      ▼
加载 项目/CLAUDE.md（项目入口）
      ├──→ .claude/rules/*.md 项目特化规则
      └──→ .claude/rules/docs-sync-map.md 同步映射
      │
      ▼
准备就绪，等待指令
```

### 规则优先级

```
项目规则 > 全局规则 > 系统默认
```

例如：全局说"不写注释"，但项目 foc.md 说"ISR 桥接代码必须写注释"，结果是有注释。

### 规则自动更新

```
Claude 修改代码
      │
      ├──→ 检查 docs-sync-map.md：此文件关联哪些文档？
      ├──→ 用 Edit 更新对应文档段落
      └──→ 架构级变更 → [RULE-CHANGE] 建议更新规则
               └──→ 你确认 → 更新规则 + 记录到 rule-changelog.md
```

### 模型路由

```
收到任务
      │
      ▼
评估复杂度
      ├── 单文件、≤30行 → 直接执行
      ├── 2-3文件、中等 → Plan 模式
      └── 4+文件、架构级 → 提示切换 pro
```

### 时效检查

```
会话启动
      │
      ▼
读 freshness.json
      ├── < 7天 → 跳过
      ├── 7-30天 → 提示轻度检查
      └── ≥ 30天 → 提示完整检查
              │
              ▼
        联网查询 cache TTL / 新工具 / 模型参数
              │
              ▼
        输出变化清单 → 你确认 → 更新规则 + freshness.json
```

## 使用实例

### 实例 1：日常 bug 修复

```
你: "CommTask.cpp:42 的 UartSend 返回 -1，帮我加个重试逻辑，最多 3 次间隔 10ms"

Claude 内部:
  1. model-routing.md → 单文件小改动，flash 模型即可
  2. efficiency.md → 用 Read(offset) 只读 CommTask.cpp:35-55
  3. core.md → 只加重试，不重构附近代码
  4. tool-selection.md → Edit 精确替换，不 Write 重写
  5. docs-sync-map.md → CommTask.cpp 无关联文档，不触发同步

Claude 输出: 改了 CommTask.cpp:42，加了 3 次重试。
```

### 实例 2：跨模块架构变更

```
你: "把 UART 从 USART0 改到 USART1，PA9/PA10 改为 PB6/PB7"

Claude:
  1. model-routing.md → 涉及 5+ 文件，提示切换 pro
  2. [MODEL] 建议切换到 pro 模型。要切换吗？
  3. 你确认 → 进入 Plan 模式

实施完成后:
  4. docs-sync-map.md 触发 → 更新 Docs/HARDWARE.md 引脚表
  5. 更新 .claude/rules/hardware.md 引脚约束
  6. safety.md → 检查无安全敏感项

Claude 输出: 改完了，5 个文件。Docs/HARDWARE.md 和 rules/hardware.md 已同步。
```

### 实例 3：规则自动演化

```
你: "上次那个 PWM 改动的确出问题了，以后改 PWM 必须先让我看过方案"

Claude:
  [RULE-CHANGE] 建议变更：safety.md
  原因：用户要求 PWM 修改前审阅方案
  当前：PWM 在 safety.md 中为"最高风险 - 确认"
  建议：升级为"最高风险 - 先出方案 + 用户审阅 + 确认"
  影响：修改 PWM 代码时先输出方案等待审阅
  是否执行？

你: yes → safety.md 更新，rule-changelog.md 记录
```

### 实例 4：时效检查

```
某天启动 Claude Code:

[FRESHNESS] 距上次检查已 32 天，需执行完整检查。

你: "执行"

Claude:
  ✓ prompt-cache-ttl: 5 分钟，无变化
  ▲ new-tool: "TaskOutput" 可用，建议加入 tool-selection.md
  ✓ models: 参数无变化
  ▲ new-hook: "PreUserPromptSubmit" 事件可用

是否更新？

你: "yes，但 new-hook 先不加"

Claude: 更新 tool-selection.md，不修改 hooks，更新 freshness.json
```

## 文件职责速查

| 我想... | 改哪个文件 |
|---------|----------|
| 让 Claude 少说话 | `~/.claude/rules/interaction.md` |
| 添加通用编码规范 | `~/.claude/rules/core.md` |
| 添加此项目独有约束 | `项目/.claude/rules/foc.md` |
| 添加新命令 | `~/.claude/skills/<名称>/SKILL.md` |
| 调整工具优先级 | `~/.claude/rules/tool-selection.md` |
| 调整模型切换阈值 | `~/.claude/rules/model-routing.md` |
| 修改文档同步映射 | `项目/.claude/rules/docs-sync-map.md` |
| 查看规则变更历史 | `~/.claude/state/rule-changelog.md` |

## 常见问题

**Q: 规则会拖慢响应吗？**

A: 全局规则约 15 个文件，大多几十行，总 token 约 3000-5000。相比无规则时的反复确认和多轮对话，整体节省。

**Q: 规则让我不爽了怎么办？**

A: 直接说 "修改规则 interaction.md，去掉 X"。或用 `/why` 先看是哪条规则在起作用。

**Q: 新项目怎么快速配置？**

A: 在项目根目录运行 `/init-project-rules`，Claude 自动分析并生成适配规则。

**Q: 规则会越来越臃肿吗？**

A: 每季度 Claude 检查长期未触发的规则，建议清理。新规则有 2 周冷却期。
