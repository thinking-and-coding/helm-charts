# Auto-Update Feature Summary

## ✅ 已完成的功能

已成功实现自动化系统来追踪 LinuxServer.io Obsidian Docker 镜像更新并自动发布新版本的 Helm chart。

## 🎯 核心功能

### 1. 自动检测更新
- ✅ 每天 00:00 UTC 自动检查新版本
- ✅ 支持手动触发
- ✅ 对比当前版本与 LinuxServer.io 最新 release
- ✅ 提取完整的 changelog 和 release notes

### 2. 通知方式（支持两种）

#### 方式一：GitHub 原生通知（推荐） ⭐
- ✅ **无需配置** - 开箱即用
- ✅ 自动创建 GitHub Issue（包含完整 changelog）
- ✅ 自动创建 Pull Request
- ✅ @mention 相关用户
- ✅ GitHub 自动发送邮件给仓库观察者
- ✅ 更安全（无需 SMTP 凭证）

#### 方式二：直接邮件通知（可选）
- ✅ 支持发送邮件到外部地址
- ✅ 支持多种 SMTP 服务（Gmail、Outlook、SendGrid 等）
- ✅ 包含完整的版本对比和 changelog

### 3. 自动发布流程

支持两种模式：

#### 模式 A：Pull Request（默认，推荐团队使用）
- ✅ 自动创建 PR 等待审核
- ✅ PR 包含完整 changelog
- ✅ 支持指定 reviewers
- ✅ 自动打标签（automated, dependencies）

#### 模式 B：自动合并（可选，适合个人项目）
- ✅ 直接提交到 main 分支
- ✅ 自动创建版本标签
- ✅ 触发现有 release workflow 发布

### 4. 版本管理
- ✅ 自动更新 Chart.yaml 的 appVersion
- ✅ 自动递增 chart version（patch +1）
- ✅ 遵循语义化版本规范

## 📁 创建的文件

1. **`.github/workflows/auto-update.yaml`**
   - GitHub Actions 工作流
   - 完整的自动更新和通知逻辑

2. **`docs/auto-update.md`**
   - 详细配置指南
   - 两种通知方式说明
   - 故障排查指南

3. **`scripts/setup-auto-update.sh`**
   - 交互式配置脚本
   - 支持两种通知方式选择
   - 自动设置所有必需的变量和密钥

4. **`scripts/README.md`**
   - 快速开始指南
   - 配置选项说明
   - SMTP 提供商示例

5. **更新的文档**
   - `README.md` - 添加 Auto-Update 文档链接
   - `CLAUDE.md` - 添加工作流使用说明
   - `.helmignore` - 修复 README.md 被排除的问题

## 🚀 快速开始

### 使用 GitHub 通知（无需配置）

最简单的方式：

1. **Watch 这个仓库**
   ```
   仓库页面 → Watch → All Activity
   ```

2. **完成！**你将自动收到：
   - 新版本发布的 GitHub Issue 通知
   - Pull Request 创建通知
   - GitHub 会自动发送邮件

### 可选配置

如果需要更多控制，运行配置脚本：

```bash
./scripts/setup-auto-update.sh
```

选择：
- **选项 1**：仅使用 GitHub 通知（推荐）
- **选项 2**：GitHub 通知 + 直接邮件

## 📧 通知示例

### GitHub Issue 通知
当检测到新版本时，会创建类似这样的 Issue：

```
标题: 🔔 New Docker Image Release: v1.10.6-ls102

内容:
## New Docker Image Release Available

**Version**: v1.10.6-ls102
**Release Date**: 2024-12-21
**Release URL**: https://github.com/linuxserver/docker-obsidian/releases/tag/v1.10.6-ls102

### Release Notes
[LinuxServer.io 的完整 changelog]

---
**Current Version:** v1.10.6-ls101
**New Version:** v1.10.6-ls102

cc: @repository-owner
```

### Pull Request 通知
自动创建的 PR 包含：
- 版本对比
- 完整 changelog
- LinuxServer.io release 链接
- @mention 配置的用户

## 🔧 配置选项

### GitHub 变量（可选）

| 变量名 | 说明 | 示例 |
|--------|------|------|
| `PR_MENTIONS` | PR 中 @mention 的用户 | `@user1 @user2` |
| `ISSUE_ASSIGNEES` | Issue 分配给谁 | `user1,user2` |
| `PR_REVIEWERS` | PR 审核者 | `user1,user2` |
| `AUTO_MERGE` | 启用自动合并 | `true` |
| `DISABLE_ISSUE_NOTIFICATION` | 禁用 Issue 通知 | `true` |

### 邮件配置（可选）

仅在需要发送邮件到外部地址时配置：

**Secrets:**
- `MAIL_SERVER`
- `MAIL_PORT`
- `MAIL_USERNAME`
- `MAIL_PASSWORD`
- `MAIL_FROM`

**Variable:**
- `NOTIFICATION_EMAIL`

## 🧪 测试

```bash
# 手动触发工作流
gh workflow run auto-update.yaml

# 查看运行状态
gh run list --workflow=auto-update.yaml

# 查看详细日志
gh run view --log
```

## 🎉 优势总结

相比传统的手动更新方式：

✅ **自动化**: 无需手动检查更新
✅ **及时**: 每天自动检查，第一时间发现新版本
✅ **安全**: 使用 GitHub 原生通知，无需 SMTP 凭证
✅ **便捷**: PR 模式支持代码审查
✅ **灵活**: 支持自动合并或 PR 审核两种模式
✅ **完整**: 包含完整的 changelog 分析
✅ **可追溯**: 所有更新都有记录和通知

## 📚 更多文档

- [完整配置指南](../docs/auto-update.md)
- [配置脚本说明](../scripts/README.md)
- [工作流文件](../.github/workflows/auto-update.yaml)

## 💡 推荐做法

1. **个人项目**: Watch 仓库 + 启用 AUTO_MERGE
2. **团队项目**: Watch 仓库 + PR 审核模式 + 设置 reviewers
3. **企业项目**: PR 审核模式 + 配置邮件通知到团队邮箱

## 🆘 需要帮助？

查看文档或在仓库中创建 Issue。
