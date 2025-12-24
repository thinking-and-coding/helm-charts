# GitHub 仓库设置 - 允许 Actions 创建 PR

## 问题

如果你看到这个错误：
```
GitHub Actions is not permitted to create or approve pull requests.
```

## 解决方案

需要在 GitHub 仓库设置中允许 GitHub Actions 创建和批准 Pull Requests。

### 步骤

1. **进入仓库设置**
   - 访问: `https://github.com/thinking-and-coding/obsidian-helm-chart/settings`
   - 或点击仓库页面的 "Settings" 标签

2. **配置 Actions 权限**
   - 左侧菜单选择 "Actions" → "General"
   - 滚动到 "Workflow permissions" 部分

3. **设置权限**
   选择以下选项之一：

   **选项 A：读写权限（推荐）**
   - ✅ 选择 "Read and write permissions"
   - ✅ 勾选 "Allow GitHub Actions to create and approve pull requests"

   **选项 B：仅创建 PR 权限（更严格）**
   - 保持 "Read repository contents and packages permissions"
   - ✅ 勾选 "Allow GitHub Actions to create and approve pull requests"

4. **保存设置**
   - 点击 "Save" 按钮

## 验证

设置完成后，重新运行工作流：

```bash
gh workflow run auto-update.yaml
```

然后检查状态：

```bash
gh run list --workflow=auto-update.yaml --limit 1
```

## 安全说明

勾选 "Allow GitHub Actions to create and approve pull requests" 是安全的，因为：
- ✅ 只有你的工作流可以创建 PR
- ✅ PR 仍然可以被审查
- ✅ 分支保护规则仍然有效
- ✅ 工作流文件需要经过审查才能合并到 main

## 替代方案（不推荐）

如果不想更改仓库设置，可以：
1. 创建一个 Personal Access Token (PAT)
2. 将 PAT 存储为 repository secret
3. 修改工作流使用 PAT 而不是 GITHUB_TOKEN

但这种方式不如仓库设置方便和安全。

## 相关文档

- [GitHub Actions Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token)
- [peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request)
