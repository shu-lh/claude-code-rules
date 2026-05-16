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

## 2. Quarterly Cleanup [SHOULD]

每季度第一天（1月1日、4月1日、7月1日、10月1日），会话启动时检查：

- 超过 90 天未触发的规则 → 建议删除或归档
- 过期条件已满足的规则 → 建议删除
- 与现有规则冲突的规则 → 建议合并

输出清理建议列表，等用户确认后执行。

## 3. New Rule Cooldown [SHOULD]

新增规则先以 [SHOULD] 级别生效 2 周。
2 周后根据实际效果升级为 [MUST] 或降级删除。

## 4. Rule Effectiveness Self-Assessment [SHOULD]

会话结束时，Claude 做简短自评（记录到 state/lessons.md）：
- 本会话是否因规则受益？
- 哪条规则最有帮助？
- 哪条规则造成了阻碍？
