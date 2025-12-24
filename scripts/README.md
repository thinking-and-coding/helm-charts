# Auto-Update Configuration

This directory contains scripts for configuring the auto-update workflow.

## Quick Start - No Configuration Needed! ✅

The easiest way to receive notifications is to use **GitHub's native notification system**:

1. **Watch this repository:**
   - Go to the repository page
   - Click "Watch" → "All Activity"
   - Done! You'll receive GitHub emails automatically

2. **Configure notifications (optional):**
   ```bash
   # Run the interactive setup script
   ./scripts/setup-auto-update.sh

   # Select "1" for GitHub Notifications Only (recommended)
   ```

## Notification Methods

### Method 1: GitHub Notifications (Recommended) ✅

**Advantages:**
- ✅ Zero configuration required
- ✅ No SMTP credentials needed
- ✅ Integrated with GitHub
- ✅ Automatic email via GitHub
- ✅ More secure

**How it works:**
- New releases create a GitHub Issue with full changelog
- Pull Requests are created automatically
- @mentions notify specific users
- GitHub sends emails to all watchers

### Method 2: Direct Email (Optional)

For sending emails to external addresses not linked to GitHub accounts.

**Required:**
- SMTP server credentials
- Run setup script and select option "2"

## Setup Script

The interactive setup script supports both methods:

```bash
./scripts/setup-auto-update.sh
```

**Features:**
- Interactive configuration
- Auto-detects GitHub CLI
- Sets all variables and secrets
- Validates authentication
- Provides testing instructions

## Manual Configuration

### GitHub Notifications Only

Set these repository variables (all optional):

```bash
gh variable set PR_MENTIONS --body "@user1 @user2"
gh variable set ISSUE_ASSIGNEES --body "user1,user2"
gh variable set PR_REVIEWERS --body "user1,user2"
```

### Adding Email Notifications

Set these repository secrets:

| Secret Name | Description | Example |
|------------|-------------|---------|
| `MAIL_SERVER` | SMTP server | `smtp.gmail.com` |
| `MAIL_PORT` | SMTP port | `587` |
| `MAIL_USERNAME` | SMTP username | `user@gmail.com` |
| `MAIL_PASSWORD` | SMTP password | `app-password` |
| `MAIL_FROM` | From address | `user@gmail.com` |

And variable:

```bash
gh variable set NOTIFICATION_EMAIL --body "external@example.com"
```

## Common SMTP Providers

### Gmail

1. Enable 2-Step Verification
2. Generate App Password at https://myaccount.google.com/apppasswords
3. Configure:
   - Server: `smtp.gmail.com`
   - Port: `587`
   - Use app password (not account password)

### Outlook/Office 365

- Server: `smtp.office365.com`
- Port: `587`
- Use account password

### Other Providers

See [docs/auto-update.md](../docs/auto-update.md) for SendGrid, Mailgun, AWS SES, etc.

## Testing

```bash
# Trigger workflow manually
gh workflow run auto-update.yaml

# Check status
gh run list --workflow=auto-update.yaml

# View logs
gh run view --log
```

## Configuration Options

| Variable | Purpose | Default |
|----------|---------|---------|
| `PR_MENTIONS` | Users to @mention in PRs | (none) |
| `ISSUE_ASSIGNEES` | Users to assign issues | (none) |
| `PR_REVIEWERS` | PR reviewers | (none) |
| `AUTO_MERGE` | Auto-commit to main | `false` |
| `DISABLE_ISSUE_NOTIFICATION` | Only use PRs | `false` |
| `NOTIFICATION_EMAIL` | Email for direct notifications | (none) |

## Troubleshooting

### Not receiving GitHub notifications

1. Watch the repository: Watch → All Activity
2. Check GitHub notification settings
3. Verify email in GitHub account settings

### Email not sending

1. Verify all MAIL_* secrets are set
2. For Gmail, use App Password
3. Check workflow logs for errors

## See Also

- [Complete Documentation](../docs/auto-update.md)
- [Workflow File](../.github/workflows/auto-update.yaml)
- [GitHub Notifications Settings](https://github.com/settings/notifications)
