<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Token & Cache Efficiency [MUST]

## 1. Cache Window Awareness [MUST]

Prompt cache TTL ~5 分钟。在此窗口内连续操作命中缓存。

- 连续改动保持节奏，中间不停 5 分钟以上
- 批量提问优于逐个提问——一次说清楚 3-5 件事
- 读大文件后不在同一个缓存窗口内做无关操作

## 2. Context Budget Management [MUST]

- 只读当前任务必需的文件，不读无关文件
- 完成独立任务后建议用户 /clear
- 不加载超过 500 行的大文件全文，用 offset/limit 分段读取
- 不主动请求读取与当前任务无关的文件

模型选择也直接影响 token 效率——简单任务用 flash 模型、复杂任务切 pro 模型，详见 `model-routing.md`。

### 2.1 Context Overflow Recovery [SHOULD]

系统自动压缩上下文（compact）后恢复执行时：
- 先确认当前进度：说明已完成步骤和下一步计划，不重复已完成的步骤
- 如果进度不明确，先询问用户"之前进行到哪了？"而非猜测
- 关键决策和中间结果已记录到 `state/lessons.md` 的不重复记录

临近上下文限制时（收到 compact 提示或输出截断）：
- 主动请求 /clear 或建议用户开启新会话
- 不尝试在受限上下文中继续复杂操作

## 3. Tool Call Economy [MUST]

- 多个无依赖操作放在一条消息中并行调用
- 不主动调用 WebFetch/WebSearch，除非用户明确要求
- 能用 Edit 不 Write 整个文件
- 能用 Grep/Glob 不用 Bash(find/grep)

## 4. Output Economy [MUST]

- 一句话说明做了什么，不写段落总结
- 不改代码时，回复 1-3 句即可
- 不解释 WHAT（代码命名已说明），只解释 WHY（非显而易见的约束）
