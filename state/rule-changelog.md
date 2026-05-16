# Rule Change Log

Records all confirmed rule changes.

## Format

```
## YYYY-MM-DD — <rule file>
- **Trigger**: <freshness-check | user-request | mistake-correction | conflict-resolution | arch-change>
- **Before**: <old content summary>
- **After**: <new content summary>
- **Approved by**: user
```

---

## 2026-05-17 — Initial creation
- **Trigger**: user-request
- **Before**: (none)
- **After**: 13 rules + 3 skills + 2 hooks created
- **Approved by**: user

## 2026-05-17 — Audit fixes
- **Trigger**: audit-rules
- **Before**: core.md §1 无交叉引用 / 5 skills 无 experimental 状态 / audit-rules 缺 Constraints / build-and-flash 缺 Constraints / check-freshness 缺参数校验说明 / project .claude/CLAUDE.md 缺 Skills 表 / project USER_GUIDE.md 缺 build-and-flash 条目
- **After**: core.md §1 增加交叉引用 / 5 skills 增加 status: experimental / audit-rules + build-and-flash 增加 Constraints / check-freshness 增加参数校验行为 / project CLAUDE.md + USER_GUIDE.md 注册 build-and-flash
- **Approved by**: user
