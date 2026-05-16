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

## 2. Analysis Steps

### 2.1 Project Type Detection
- 检查构建系统（CMakeLists.txt / Makefile / Cargo.toml / package.json / go.mod 等）
- 识别语言（C/C++/Rust/Python/Go 等）
- 识别平台（嵌入式 → 查 MCU 型号、RTOS、工具链）

### 2.2 Key Parameters Extraction
- MCU 型号 → linker script 或 datasheet
- RTOS 配置 → FreeRTOSConfig.h 或同类文件
- 外设引脚 → pin definitions 或 HARDWARE.md
- 任务配置 → 任务创建代码
- 内存配置 → linker script + RTOS heap 配置

### 2.3 Document Inventory
列出项目中已有的说明文件，避免覆盖。

## 3. Auto-Generation

### 3.1 CLAUDE.md
- 架构概述（3 句话）
- 构建命令
- 任务优先级表（如适用）
- 关键模式
- 硬约束

### 3.2 .claude/rules/
- 从全局 embedded/constraints.md 实例化 → foc.md / hardware.md
- 从全局 core.md 实例化 → 项目特化约束
- 创建 docs-sync-map.md（代码→文档映射表）
- 创建 safety.md（如涉及硬件）

### 3.3 Confirmation
生成完以后，向用户展示：
- 创建了哪些文件
- 各文件的主要内容摘要
- 请求用户审核确认

## 4. On Existing Projects

如果项目已有 CLAUDE.md → 只建议补充，不覆盖。
如果项目已有 .claude/rules/ → 只建议补充缺失的规则。
