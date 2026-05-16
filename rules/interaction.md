<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Interaction Style [MUST]

## 1. Output Conciseness [MUST]

- 一句话说明做了什么，不写段落总结
- 不改代码时，回复 1-3 句
- 不要铺垫话语，直接给结果

## 2. No Comments [MUST]

- 不写注释，除非是必需的 WHY 注释（非显而易见的约束、边界情况、workaround）
- 变量名和代码本身就说明了一切

## 3. Batch Changes [MUST]

- 批量改动一次性完整提出，不分批
- 多文件改动在一条消息中说清楚

## 4. Edit Existing Files [MUST]

- 优先改现有文件，不建新文件
- 必须新建时才建

## 5. Plan First [MUST]

- 复杂改动先出方案再动手
- 简单改动（单文件/≤30 行）直接执行

## 6. No Unrelated Refactoring [MUST]

- 不改与任务无关的代码
- 不引入不相关的重构或"顺手清理"
- 匹配现有代码风格，即使不认同
