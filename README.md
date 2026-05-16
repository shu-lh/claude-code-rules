# Claude Code Rules

模块化 Claude Code 两级规则系统——全局通用规范 + 项目特化约束。

## 核心设计

```
~/.claude/                ← 全局规则（所有项目通用）
  ├── rules/   # 行为约束
  ├── skills/  # 可调用技能
  ├── hooks/   # 事件触发脚本
  └── state/   # 运行时数据模板

项目/.claude/             ← 项目规则（从全局模板实例化）
  ├── CLAUDE.md
  ├── rules/   # 项目级约束
  └── skills/  # 项目特化技能
```

### 规则分两类传递

| 类型 | 传递方式 | 示例 |
|------|---------|------|
| 直接继承型 | 所有项目原样生效 | interaction.md, efficiency.md, tool-selection.md, git.md |
| 模板实例化型 | 含"Project Instantiation"段，Claude 进入项目时填入具体参数 | core.md, embedded/constraints.md, documentation.md |

### 核心能力

- **Token/缓存效率** — 缓存窗口感知、上下文预算、工具选择优先级、输出精简
- **规则变更通知** — `[RULE-CHANGE]` 格式，用户确认后执行，自动连带检查
- **文档自动同步** — 代码变更 → docs-sync-map → 更新关联文档
- **模型自动路由** — 三级复杂度评估（简单→flash、中等→Plan、复杂→建议切换）
- **规则时效检查** — 定期联网验证 cache TTL、模型参数、工具变化
- **项目自动构建** — `/init-project-rules` 分析项目瞬间生成适配规则

## 快速安装

```bash
git clone https://github.com/YOUR_USER/claude-code-rules.git /tmp/cr-setup
cp -r /tmp/cr-setup/{CLAUDE.md,rules,skills,hooks,state,USER_GUIDE.md} ~/.claude/
# settings.template.json 手动合并到 ~/.claude/settings.json（不要直接覆盖）
```

可选安装特定领域规则：

```bash
cp -r /tmp/cr-setup/rules/embedded ~/.claude/rules/
```

## 在新项目中使用

```
/init-project-rules
```

Claude 自动分析项目生成 `.claude/` 下的特化规则。

## 目录结构

```
rules/
├── core.md              # [MUST] 核心工程纪律（四原则 + 冲突 + 环境检查）
├── interaction.md       # [MUST] 交互风格
├── efficiency.md        # [MUST] Token/缓存效率
├── tool-selection.md    # [MUST] 工具选择优先级矩阵
├── model-routing.md     # [MUST] 模型自动路由
├── rule-change.md       # [MUST] 变更通知 + 连带更新 + 放置/排序
├── documentation.md     # [MUST] 文档同步更新
├── rule-lifecycle.md    # [SHOULD] 规则退化防护
├── debugging.md         # [SHOULD] 规则调试（/why、紧急旁路）
├── freshness.md         # [MUST] 规则时效检查
├── git.md               # [SHOULD] Git 工作流
├── embedded/
│   ├── constraints.md   # [MUST] 嵌入式硬约束
│   └── cpp.md           # [SHOULD] 嵌入式 C++ 规范
└── PROJECT_INIT.md      # 项目初始化流程

skills/
├── check-freshness/SKILL.md       # 时效检查
├── init-project-rules/SKILL.md    # 项目规则构建
└── why/SKILL.md                   # 决策追溯

hooks/
├── check-freshness-trigger.sh     # 时效提醒
└── doc-sync-reminder.sh           # 文档提醒

state/
├── freshness.json      # 时效状态（模板）
├── lessons.md          # 错题本（模板）
└── rule-changelog.md   # 变更日志（模板）

USER_GUIDE.md           # 用户指南
CLAUDE.md               # 全局规则索引
settings.template.json  # 权限配置模板
```

## 自定义

1. Fork 此仓库
2. 修改 `rules/` 下规则内容
3. 添加你的 `skills/` 和 `hooks/`
4. 提交推送到你的仓库
5. 新设备 `git clone` 即可安装

## 更新

```bash
cd ~/.claude-rules-repo
git pull
cp -r {CLAUDE.md,rules,skills,hooks,state,USER_GUIDE.md} ~/.claude/
```

## 许可证

MIT
