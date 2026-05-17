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

## 4. Commit Approval [MUST]

- 不自动执行 commit，除非用户明确要求
- 用户要求 commit 时：
  1. 展示变更摘要（git diff --stat）和 commit 信息草案
  2. 等待用户明确确认后执行
- 不跳过 hooks（--no-verify）
- 不 amend 已发布的 commit

## 5. Co-Authored-By 署名 [MUST]

- 共同作者行必须使用当前运行的实际模型名（从系统提示 `powered by the model` 获取）
- 格式：`<模型名> <noreply@所属厂商.com>`
- 示例（deepseek-v4-flash）：`DeepSeek v4 Flash <noreply@deepseek.com>`
- 禁止硬编码为其他模型名（如 Claude Opus 4.7）
