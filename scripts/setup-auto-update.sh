#!/bin/bash
#
# Quick setup script for auto-update notifications
#
# Usage: ./setup-auto-update.sh
#

set -e

echo "================================================"
echo "Obsidian Helm Chart - Auto-Update Setup"
echo "================================================"
echo ""
echo "This script will help you configure notifications"
echo "for automated Docker image updates."
echo ""

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) is not installed."
    echo ""
    echo "Please install it first:"
    echo "  - macOS: brew install gh"
    echo "  - Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  - Windows: https://github.com/cli/cli#installation"
    echo ""
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI"
    echo ""
    echo "Please run: gh auth login"
    echo ""
    exit 1
fi

echo "✅ GitHub CLI is authenticated"
echo ""

# Get current repository
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")

if [ -z "$REPO" ]; then
    echo "❌ Not in a GitHub repository directory"
    exit 1
fi

echo "📦 Repository: $REPO"
echo ""

echo "=== Notification Method Selection ==="
echo ""
echo "Choose your notification method:"
echo ""
echo "1. GitHub Notifications Only (Recommended) ✅"
echo "   - No configuration needed"
echo "   - Uses GitHub Issues and Pull Requests"
echo "   - Automatic email via GitHub"
echo "   - Most secure option"
echo ""
echo "2. GitHub + Direct Email Notifications"
echo "   - GitHub notifications PLUS direct emails"
echo "   - Requires SMTP configuration"
echo "   - Useful for external email addresses"
echo ""

read -p "Select option [1/2] (default: 1): " NOTIFICATION_METHOD

if [ -z "$NOTIFICATION_METHOD" ]; then
    NOTIFICATION_METHOD="1"
fi

echo ""
echo "=== GitHub Notification Configuration ==="
echo ""

read -p "Users to @mention in PRs (e.g., @user1 @user2) [optional]: " PR_MENTIONS
read -p "Users to assign to issues (comma-separated, e.g., user1,user2) [optional]: " ISSUE_ASSIGNEES
read -p "PR reviewers (comma-separated, e.g., user1,user2) [optional]: " PR_REVIEWERS

# Email configuration only if option 2 is selected
if [ "$NOTIFICATION_METHOD" = "2" ]; then
    echo ""
    echo "=== Email Configuration ==="
    echo ""

    read -p "SMTP Server (e.g., smtp.gmail.com): " MAIL_SERVER
    read -p "SMTP Port (e.g., 587): " MAIL_PORT
    read -p "SMTP Username: " MAIL_USERNAME
    read -s -p "SMTP Password (App Password for Gmail): " MAIL_PASSWORD
    echo ""
    read -p "Notification Email Address: " NOTIFICATION_EMAIL
    read -p "From Email (press Enter to use username): " MAIL_FROM

    if [ -z "$MAIL_FROM" ]; then
        MAIL_FROM="$MAIL_USERNAME"
    fi
fi

echo ""
echo "=== Optional Configuration ==="
echo ""

read -p "Enable auto-merge (directly push to main)? [y/N]: " AUTO_MERGE_INPUT
AUTO_MERGE="false"
if [[ "$AUTO_MERGE_INPUT" =~ ^[Yy]$ ]]; then
    AUTO_MERGE="true"
    echo "⚠️  WARNING: Auto-merge will push changes directly to main branch!"
fi

read -p "Disable issue notifications (only use PRs)? [y/N]: " DISABLE_ISSUE_INPUT
DISABLE_ISSUE="false"
if [[ "$DISABLE_ISSUE_INPUT" =~ ^[Yy]$ ]]; then
    DISABLE_ISSUE="true"
fi

echo ""
echo "=== Setting GitHub Variables ==="
echo ""

# Set GitHub notification variables
if [ -n "$PR_MENTIONS" ]; then
    echo "Setting PR_MENTIONS..."
    gh variable set PR_MENTIONS --body "$PR_MENTIONS"
fi

if [ -n "$ISSUE_ASSIGNEES" ]; then
    echo "Setting ISSUE_ASSIGNEES..."
    gh variable set ISSUE_ASSIGNEES --body "$ISSUE_ASSIGNEES"
fi

if [ -n "$PR_REVIEWERS" ]; then
    echo "Setting PR_REVIEWERS..."
    gh variable set PR_REVIEWERS --body "$PR_REVIEWERS"
fi

if [ "$AUTO_MERGE" = "true" ]; then
    echo "Setting AUTO_MERGE..."
    gh variable set AUTO_MERGE --body "true"
fi

if [ "$DISABLE_ISSUE" = "true" ]; then
    echo "Setting DISABLE_ISSUE_NOTIFICATION..."
    gh variable set DISABLE_ISSUE_NOTIFICATION --body "true"
fi

# Set email secrets if option 2 was selected
if [ "$NOTIFICATION_METHOD" = "2" ]; then
    echo ""
    echo "=== Setting Email Secrets ==="
    echo ""

    echo "Setting MAIL_SERVER..."
    echo "$MAIL_SERVER" | gh secret set MAIL_SERVER

    echo "Setting MAIL_PORT..."
    echo "$MAIL_PORT" | gh secret set MAIL_PORT

    echo "Setting MAIL_USERNAME..."
    echo "$MAIL_USERNAME" | gh secret set MAIL_USERNAME

    echo "Setting MAIL_PASSWORD..."
    echo "$MAIL_PASSWORD" | gh secret set MAIL_PASSWORD

    echo "Setting MAIL_FROM..."
    echo "$MAIL_FROM" | gh secret set MAIL_FROM

    echo "Setting NOTIFICATION_EMAIL..."
    gh variable set NOTIFICATION_EMAIL --body "$NOTIFICATION_EMAIL"
fi

echo ""
echo "✅ Configuration complete!"
echo ""
echo "=== Next Steps ==="
echo ""

if [ "$NOTIFICATION_METHOD" = "1" ]; then
    echo "📧 GitHub Notifications:"
    echo "   1. Watch this repository to receive notifications"
    echo "      Repository → Watch → All Activity"
    echo ""
    echo "   2. Configure your GitHub notification preferences:"
    echo "      Settings → Notifications"
    echo ""
fi

echo "🧪 Test the setup:"
echo "   1. Manually trigger the workflow:"
echo "      gh workflow run auto-update-obsidian.yaml"
echo ""
echo "   2. Check workflow status:"
echo "      gh run list --workflow=auto-update-obsidian.yaml"
echo ""
echo "   3. View workflow logs:"
echo "      gh run view --log"
echo ""

echo "⏰ Automatic execution:"
echo "   The workflow runs automatically every day at 00:00 UTC"
echo ""

if [ "$AUTO_MERGE" = "true" ]; then
    echo "⚠️  Auto-merge is ENABLED - updates will be pushed directly to main"
else
    echo "📝 Auto-merge is DISABLED - updates will create Pull Requests for review"
fi

if [ "$DISABLE_ISSUE" = "true" ]; then
    echo "ℹ️  Issue notifications are DISABLED - only PRs will be created"
else
    echo "📋 Issue notifications are ENABLED - issues will be created for new releases"
fi

echo ""
echo "For more information, see docs/auto-update.md"
echo ""
