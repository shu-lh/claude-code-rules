<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: always
过期条件: none
-->

# Git Workflow [SHOULD]

## 1. Commit Style [SHOULD]

- 使用 Conventional Commits：`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- 提交信息用中文描述（本用户偏好）

## 2. Branch Discipline [SHOULD]

- 不在 main 分支上直接编辑
- 功能开发在 feature 分支
- 提交前确认 git status 无误

## 3. Dangerous Operations [MUST]

以下操作需用户明确确认：
- `git push --force`
- `git reset --hard`
- `git checkout -- <file>`（丢弃修改）
- `git branch -D`
- 修改 git config

## 4. Commit Workflow [MUST]

- 不自动 commit，除非用户明确要求
- Commit 前展示 staged changes 摘要
- 不跳过 hooks（--no-verify）
- 不 amend 已发布的 commit
