# Scripts

Utility scripts for repository management and automation.

## Available Scripts

### `setup-auto-update.sh`

Interactive script to configure automated version tracking for charts.

**Purpose:**
- Configures GitHub Actions workflow variables and secrets
- Sets up notification preferences (GitHub Issues, Email, or both)
- Configures auto-merge behavior

**Usage:**
```bash
# Run interactively
./scripts/setup-auto-update.sh

# For a specific chart (if applicable)
CHART_NAME=obsidian ./scripts/setup-auto-update.sh
```

**What it configures:**

1. **Notification Method**:
   - GitHub Issues (default, zero config)
   - Email notifications (requires SMTP settings)
   - Both

2. **Auto-Update Behavior**:
   - PR Mode: Creates pull request for review (default, recommended)
   - Auto-Merge: Automatically commits and tags

3. **Secrets** (for email notifications):
   - `MAIL_SERVER`: SMTP server address
   - `MAIL_PORT`: SMTP port (default: 587)
   - `MAIL_USERNAME`: SMTP username
   - `MAIL_PASSWORD`: SMTP password
   - `MAIL_FROM`: From email address

4. **Variables**:
   - `NOTIFICATION_EMAIL`: Email recipient
   - `AUTO_MERGE`: Enable auto-merge mode ('true'/'false')
   - `DISABLE_ISSUE_NOTIFICATION`: Disable GitHub Issues
   - `PR_REVIEWERS`: GitHub usernames for PR review
   - `PR_MENTIONS`: Additional users to mention
   - `ISSUE_ASSIGNEES`: Users to assign issues to

**Prerequisites:**
- [GitHub CLI](https://cli.github.com/) installed and authenticated
- Repository permissions to modify secrets/variables

**Currently supports:**
- Obsidian chart auto-update

**Adding support for other charts:**
Update the script to reference the appropriate workflow file for each chart.

## Future Scripts

Planned utility scripts:

- **`create-chart.sh`**: Scaffold a new chart with standard structure
- **`bump-version.sh`**: Automate chart version bumping
- **`validate-chart.sh`**: Pre-commit validation script
- **`generate-docs.sh`**: Auto-generate documentation from values.yaml

## Development

### Adding New Scripts

1. Create script in `scripts/` directory
2. Make executable: `chmod +x scripts/your-script.sh`
3. Add usage documentation here
4. Test thoroughly before committing

### Script Guidelines

- Use `#!/bin/bash` shebang
- Include usage/help message
- Validate prerequisites
- Provide clear error messages
- Support dry-run mode where applicable
- Document all environment variables

## Usage Examples

### Setup Auto-Update for Obsidian

```bash
./scripts/setup-auto-update.sh
```

Follow the interactive prompts to configure:
1. Notification method
2. SMTP settings (if using email)
3. Auto-merge preference
4. GitHub credentials for setting secrets/variables

### Verify Configuration

```bash
# Check repository variables
gh variable list

# Check repository secrets (names only)
gh secret list

# Test workflow manually
gh workflow run auto-update-obsidian.yaml

# Check workflow run status
gh run list --workflow=auto-update-obsidian.yaml
```

## Troubleshooting

### "gh: command not found"

Install GitHub CLI:
```bash
# macOS
brew install gh

# Linux
# See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

# Authenticate
gh auth login
```

### Permission Denied

Make script executable:
```bash
chmod +x scripts/setup-auto-update.sh
```

### "Insufficient permissions"

Ensure your GitHub token has:
- `repo` scope (for secrets and variables)
- `workflow` scope (for workflow dispatch)

Re-authenticate:
```bash
gh auth refresh -s repo,workflow
```

## Related Documentation

- [Auto-Update Documentation](../charts/obsidian/docs/auto-update.md) - Obsidian chart auto-update setup
- [CI/CD Documentation](../docs/ci-cd.md) - GitHub Actions workflows
- [Contributing Guide](../docs/contributing.md) - How to contribute

## Support

For script issues:
1. Check script output for error messages
2. Verify prerequisites are installed
3. Review related documentation
4. Open an issue with script output and environment details
