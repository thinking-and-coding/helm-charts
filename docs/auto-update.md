# Auto-Update Configuration Guide

This document explains how to configure the automated update system for tracking LinuxServer.io Obsidian Docker image releases.

## Overview

The auto-update workflow (`auto-update.yaml`) automatically:

1. **Checks for updates** daily (or on manual trigger)
2. **Analyzes changelog** from LinuxServer.io releases
3. **Sends notifications** via GitHub Issues/PRs (and optionally email)
4. **Creates Pull Requests** or **auto-releases** new chart versions

## Notification Methods

### Method 1: GitHub Native Notifications (Recommended) ✅

**No configuration needed!** Uses GitHub's built-in notification system:

- **GitHub Issues**: Creates an issue for each new release (disabled in auto-merge mode)
- **Pull Requests**: PR creation automatically notifies watchers and reviewers
- **@mentions**: Mentions repository owner and configured users
- **Email**: GitHub sends emails to all repository watchers automatically

**Advantages:**
- ✅ Zero configuration required
- ✅ No SMTP credentials needed
- ✅ Integrated with GitHub notifications
- ✅ Works for all repository watchers
- ✅ More secure (no external credentials)

**To receive notifications:**
1. Watch the repository (Repository → Watch → All Activity)
2. Configure notification preferences in GitHub settings
3. Optionally set `ISSUE_ASSIGNEES` or `PR_MENTIONS` variables

### Method 2: Email Notifications (Optional)

For sending direct emails to specific addresses (useful for external notifications):

**Required configuration:**
- SMTP server credentials (see Email Notification Setup section)
- `NOTIFICATION_EMAIL` variable

## Quick Start (GitHub Notifications Only)

**No setup required!** Just:

1. **Watch the repository:**
   - Go to repository page
   - Click "Watch" → "All Activity"

2. **Configure notification preferences** (optional):
   ```bash
   # Add users to mention in PRs (comma-separated GitHub usernames)
   gh variable set PR_MENTIONS --body "@user1 @user2"

   # Add users to assign to issues (comma-separated GitHub usernames)
   gh variable set ISSUE_ASSIGNEES --body "user1,user2"

   # Add PR reviewers (comma-separated GitHub usernames)
   gh variable set PR_REVIEWERS --body "user1,user2"
   ```

3. **Done!** You'll receive GitHub notifications when:
   - New Docker image releases are detected (via Issue)
   - Pull Requests are created (via PR notification)
   - You're mentioned in updates

## Setup Instructions

### 1. GitHub Notification Configuration (Recommended)

#### Repository Variables

Set these variables in `Settings` → `Secrets and variables` → `Actions` → `Variables`:

| Variable Name | Description | Example |
|--------------|-------------|---------|
| `PR_MENTIONS` | Users to @mention in PRs | `@user1 @user2` |
| `ISSUE_ASSIGNEES` | Users to assign to issues | `user1,user2` |
| `PR_REVIEWERS` | PR reviewers | `user1,user2` |
| `DISABLE_ISSUE_NOTIFICATION` | Disable issue creation | `true` (optional) |

#### Personal Notification Settings

Configure your GitHub notification preferences:
1. GitHub Settings → Notifications
2. Enable "Email" for "Participating, @mentions and custom"
3. Enable "Watching" notifications if desired

### 2. Email Notification Setup (Optional)

To enable email notifications, configure the following secrets and variables in your GitHub repository:

#### Repository Secrets

Go to `Settings` → `Secrets and variables` → `Actions` → `New repository secret`:

- `MAIL_SERVER`: SMTP server address (e.g., `smtp.gmail.com`)
- `MAIL_PORT`: SMTP port (e.g., `587` for TLS, `465` for SSL)
- `MAIL_USERNAME`: SMTP authentication username
- `MAIL_PASSWORD`: SMTP authentication password
- `MAIL_FROM`: (Optional) Sender email address (defaults to MAIL_USERNAME)

#### Repository Variables

Go to `Settings` → `Secrets and variables` → `Actions` → `Variables` tab → `New repository variable`:

- `NOTIFICATION_EMAIL`: Email address to receive notifications (e.g., `maintainer@example.com`)

#### Example: Gmail Configuration

For Gmail, you need to use an App Password:

1. Enable 2-Step Verification on your Google Account
2. Generate an App Password at https://myaccount.google.com/apppasswords
3. Configure secrets:
   - `MAIL_SERVER`: `smtp.gmail.com`
   - `MAIL_PORT`: `587`
   - `MAIL_USERNAME`: `your-email@gmail.com`
   - `MAIL_PASSWORD`: `your-app-password` (16-character app password)
   - `MAIL_FROM`: `your-email@gmail.com`

### 2. Auto-Release Configuration

Choose between two modes:

#### Mode A: Pull Request (Default - Recommended for Teams)

New versions create a Pull Request for review before merging.

- No additional configuration needed
- PRs are created automatically
- Reviewers can be set with `PR_REVIEWERS` variable (comma-separated GitHub usernames)

#### Mode B: Automatic Release

New versions are automatically committed, tagged, and released without review.

**⚠️ Use with caution - changes are pushed directly to main!**

To enable auto-release, set repository variable:

- `AUTO_MERGE`: `true`

### 3. GitHub Permissions

The workflow uses `GITHUB_TOKEN` with the following permissions (already configured in the workflow):

- `contents: write` - To create commits and tags
- `pull-requests: write` - To create PRs

No additional token configuration is needed.

## Workflow Behavior

### Schedule

- Runs daily at 00:00 UTC
- Can be manually triggered via GitHub Actions UI

### Update Detection

The workflow compares:
- Current `appVersion` in `charts/obsidian/Chart.yaml`
- Latest release tag from `linuxserver/docker-obsidian`

If they differ, an update is triggered.

### Version Bumping

When an update is detected:
- Chart `appVersion` is updated to the latest Docker image version
- Chart `version` is auto-incremented (patch version +1)

Example:
- Docker image: `v1.10.6-ls101` → `v1.10.6-ls102`
- Chart version: `0.1.2` → `0.1.3`

### Email Notification

If configured, an email is sent with:
- Current and new versions
- Full release notes from LinuxServer.io
- Link to the release page
- Repository information

### Release Process

#### Pull Request Mode (default)

1. Creates a new branch: `auto-update/v1.10.6-ls102`
2. Commits Chart.yaml changes
3. Opens a PR with:
   - Full changelog in the description
   - Labels: `automated`, `dependencies`
   - Assigned reviewers (if configured)
4. After PR approval and merge, manually create a tag to trigger release

#### Auto-Merge Mode (AUTO_MERGE=true)

1. Commits Chart.yaml changes directly to `main`
2. Creates and pushes a tag: `v0.1.3`
3. The existing `release.yaml` workflow automatically publishes the chart

## Manual Trigger

To manually check for updates:

1. Go to `Actions` tab in GitHub
2. Select `Auto Update Chart` workflow
3. Click `Run workflow`
4. Select branch (usually `main`)
5. Click `Run workflow` button

## Testing the Setup

### Test Email Configuration

Create a test workflow run to verify email settings:

```bash
# Manually trigger the workflow
# It will check for updates and send email if configured
```

Or create a simple test by temporarily modifying the workflow to always send a test email.

### Test Auto-Update

You can test the update logic by:

1. Temporarily setting `appVersion: "v1.10.5-ls100"` in Chart.yaml (an older version)
2. Manually triggering the workflow
3. Verifying it detects the update and creates a PR or release

## Monitoring

### Workflow Status

Check workflow runs at:
- `Actions` → `Auto Update Chart`

### Notifications

You'll receive emails when:
- ✅ New Docker image version is released
- Contains full changelog and release notes
- Indicates whether auto-release or PR was created

### GitHub Notifications

You'll get GitHub notifications for:
- Pull requests created by the workflow
- Workflow failures (if email/release fails)

## Troubleshooting

### Email Not Sending

1. Verify all `MAIL_*` secrets are set correctly
2. Check `NOTIFICATION_EMAIL` variable is set
3. For Gmail, ensure App Password is used (not regular password)
4. Check workflow logs for SMTP errors

### Updates Not Detected

1. Check if `appVersion` in Chart.yaml matches the latest release
2. Verify internet connectivity in workflow (GitHub's network)
3. Check if LinuxServer.io API is accessible

### Auto-Release Not Working

1. Ensure `AUTO_MERGE` variable is set to `true`
2. Verify `GITHUB_TOKEN` has necessary permissions
3. Check for branch protection rules that might block direct pushes

## Security Considerations

- **SMTP Credentials**: Store in secrets, never in code
- **AUTO_MERGE Mode**: Only enable if you trust the automated process
- **App Passwords**: Use app-specific passwords, not account passwords
- **Email Exposure**: NOTIFICATION_EMAIL is visible in workflow logs

## Customization

### Change Check Frequency

Edit the cron schedule in `.github/workflows/auto-update.yaml`:

```yaml
schedule:
  - cron: '0 0 * * *'  # Daily at midnight UTC
  # - cron: '0 */12 * * *'  # Every 12 hours
  # - cron: '0 0 * * 1'  # Weekly on Monday
```

### Modify Version Bump Strategy

Currently increments patch version. To change to minor version bumps:

Edit the `Update Chart.yaml` step:

```bash
# Current: Increments patch (0.1.2 → 0.1.3)
NEW_PATCH=$((PATCH + 1))
NEW_CHART_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}"

# Alternative: Increment minor (0.1.2 → 0.2.0)
NEW_MINOR=$((MINOR + 1))
NEW_CHART_VERSION="${MAJOR}.${NEW_MINOR}.0"
```

### Custom Notification Template

Modify the email body in the `Send email notification` step to customize the message format.

## Maintenance

### Regular Checks

- Monitor workflow executions monthly
- Verify email notifications are being received
- Review automated PRs for accuracy

### Updating the Workflow

The workflow itself should be reviewed periodically to:
- Update action versions (e.g., `actions/checkout@v4` → `@v5`)
- Adjust to API changes from LinuxServer.io
- Improve changelog parsing logic

## Additional Resources

- [LinuxServer.io Obsidian Releases](https://github.com/linuxserver/docker-obsidian/releases)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [action-send-mail Documentation](https://github.com/dawidd6/action-send-mail)
