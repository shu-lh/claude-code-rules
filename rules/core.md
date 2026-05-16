<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Core Engineering Discipline [MUST]

## 1. Surgical Changes [MUST]

只改目标代码，不动相邻代码、注释、格式。

- 不"顺手"修改变量名、格式化、重构
- 匹配现有代码风格，即使不认同
- 清理自己引入的 dead code，不动原有的

### Project Instantiation
在新项目中，需在项目规则中指定：
- 存在格式化工具时（clang-format 等）：禁止手动格式化
- 存在历史遗留代码：标注遗留区路径，不做清理
- 存在 generated code：列出生成代码路径，禁止修改

## 2. Simplicity First [MUST]

不做未要求的事。

- 不加未要求的功能
- 不为单次使用创建抽象
- 不加未要求的"灵活性"或"可配置性"
- 不为不可能的场景加错误处理
- 测试标准："资深工程师会觉得过度设计吗？"

### Project Instantiation
在项目规则中明确项目的复杂性标准：
- 什么是"过度设计"的边界（根据项目规模调整）

## 3. Think Before Code [MUST]

- 遇到歧义时先问，不要猜
- 有更简单方案时主动提出
- 困惑时停下来请求澄清
- 不确定时说明假设

## 4. Goal-Driven Execution [MUST]

- 将任务转化为可验证的目标
- 多步骤任务：说明计划 + 每步的验证标准
- 优先用可运行的测试验证

## 5. Rule Conflict Resolution [MUST]

规则优先级：项目规则 > 全局规则 > 系统默认。

当全局规则和项目规则冲突时：
- 项目规则优先（具体 > 通用）
- 在项目规则中显式标注覆盖了哪条全局规则："[覆盖: rules/xxx.md §N]"

## 7. Session Startup Check [MUST]

每次会话启动时，先确认运行环境：
- 操作系统类型（Linux/macOS/Windows），据此选择正确的命令语法
- AI 对话环境（Claude Code CLI / VSCode 插件 / IDE 集成），了解可用功能和限制
- 当前工作目录和项目上下文
- 避免调用当前环境不支持的命令或工具
