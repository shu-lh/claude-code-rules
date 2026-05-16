---
name: init-project-rules
description: 分析当前项目并自动生成适配的 .claude/CLAUDE.md 和 .claude/rules/。用于新项目首次配置。
user-invocable: true
status: experimental
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
---

# Init Project Rules Skill

分析项目结构并生成两级规则的项目层。所有生成文件集中在 `.claude/` 目录下。

## Execution Steps

### Step 1: Detect Project Type

- 搜索 CMakeLists.txt / Makefile / Cargo.toml / package.json 等
- 判断语言和领域（C/C++ → 嵌入式 or 非嵌入式；Rust/Go/Python 等）
- 若为嵌入式 → 搜索 MCU 型号（linker script, datasheet reference）

### Step 2: Read Existing Docs

- README.md, Docs/*.md, ARCHITECTURE.md 等
- 提取：架构描述、构建命令、硬件配置、任务参数

### Step 3: Extract Key Parameters

- MCU: 从 linker script 提取 RAM/Flash 大小
- RTOS: 从 RTOS 配置文件提取 heap size, tick rate, task priorities
- Tasks: 搜索任务创建代码，提取优先级和栈大小
- Peripherals: 从引脚定义文件或硬件文档提取
- Generated code: 识别厂商 SDK、RTOS 内核、中间件等第三方代码路径

### Step 4: Generate Root CLAUDE.md (Stub)

项目根目录 `CLAUDE.md` 仅作为引用存根：

```markdown
# CLAUDE.md
本项目的 Claude Code 配置位于 `.claude/CLAUDE.md`。
所有 Claude 相关文件集中在 `.claude/` 目录下管理。
请读取 `.claude/CLAUDE.md` 获取项目指令。
```

### Step 5: Generate .claude/CLAUDE.md

基于模板：架构概述 + 构建命令 + 任务表(如适用) + 关键模式 + 硬约束 + vendor code 路径。
目标 ~100 行以内。

### Step 6: Generate .claude/rules/

- 从 `~/.claude/rules/embedded/constraints.md` 实例化 → 硬实时约束文件
- 从引脚/外设信息 → 硬件约束文件
- 串口/控制台特有约束 → 通信约束文件（如有）
- 代码→文档映射 → docs-sync-map.md
- 硬件安全清单 → safety.md（如有硬件操作）

生成的文件名根据实际内容命名，不预设固定名称。

### Step 7: Generate .claude/settings.json

项目级权限配置。

### Step 8: Copy USER_GUIDE.md

从 `~/.claude/USER_GUIDE.md` 复制到 `项目/.claude/USER_GUIDE.md`。

### Step 9: Present and Confirm

列出创建的文件清单和各文件摘要。
询问用户是否批准。

## Constraints

- 不覆盖已存在的文件（询问用户后决定）
- 所有数值必须有来源（标注提取自哪个文件的哪一行）
- 全局规则中不引用项目具体路径或名称
- 总生成时间控制在 3 轮对话以内
