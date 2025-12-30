# CI/CD Pipeline Documentation

This document explains the continuous integration and deployment pipelines for this Helm charts repository.

## Overview

The repository uses GitHub Actions for automated testing and releasing of Helm charts. All workflows are designed to support multiple charts automatically.

## Workflows

### 1. Lint and Test (`lint-test.yaml`)

**Triggers:**
- Pull requests affecting `charts/**`
- Pushes to `main` branch affecting `charts/**`
- Changes to workflow or ct.yaml files

**Jobs:**

#### `lint`
Validates chart syntax and best practices.

```bash
# Runs for each chart
helm lint charts/*/

# Uses chart-testing for comprehensive validation
ct lint --config .github/ct.yaml --all
```

**What it checks:**
- Chart.yaml validity
- values.yaml syntax
- Template syntax
- Kubernetes resource validity
- Chart best practices compliance
- Maintainer validation (disabled via ct.yaml)

#### `test`
Performs integration testing in a Kubernetes cluster.

```bash
# Creates a kind (Kubernetes in Docker) cluster
kind create cluster

# Installs and tests charts
ct install --config .github/ct.yaml --all
```

**What it does:**
- Detects changed charts (compares with main branch)
- Creates a temporary Kubernetes cluster
- Installs each changed chart
- Runs chart tests (templates/tests/)
- Verifies successful deployment

#### `template`
Tests template rendering with various configurations.

```bash
# For each chart:
#   1. Template with default values
helm template test-release charts/obsidian/

#   2. Template with each example file
helm template test-release charts/obsidian/ -f charts/obsidian/examples/values-production.yaml
```

**What it validates:**
- Templates render without errors
- All example values files work
- No syntax errors in generated manifests

### 2. Release Charts (`release.yaml`)

**Triggers:**
- Git tags matching `v*.*.*` pattern
  - Examples: `v0.1.3`, `obsidian-v0.1.3`, `myapp-v1.0.0`

**What it does:**

1. **Detects Changed Charts**: Compares with previous release
2. **Packages Charts**: Creates `.tgz` archives
3. **Creates GitHub Releases**: For each chart
4. **Publishes to GitHub Pages**: Updates Helm repository index
5. **Uploads Artifacts**: Attaches chart packages

**Using [helm/chart-releaser-action](https://github.com/helm/chart-releaser-action):**

```yaml
- uses: helm/chart-releaser-action@v1.6.0
  with:
    charts_dir: charts      # Scans all subdirectories
    skip_existing: true     # Avoids re-releasing unchanged charts
```

**Process:**
```
Tag pushed (v0.2.0)
  ↓
Chart releaser detects changes
  ↓
Packages chart → obsidian-0.2.0.tgz
  ↓
Creates GitHub Release with notes
  ↓
Updates gh-pages branch with index.yaml
  ↓
Chart available via Helm repo
```

### 3. Auto-Update Obsidian (`auto-update-obsidian.yaml`)

**Triggers:**
- Daily at 00:00 UTC (cron schedule)
- Manual workflow dispatch

**Jobs:**

#### `check-updates`
Monitors LinuxServer.io Docker releases.

```bash
# Gets current version from Chart.yaml
CURRENT_VERSION=$(grep '^appVersion:' charts/obsidian/Chart.yaml | awk '{print $2}' | tr -d '"')

# Fetches latest release from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/linuxserver/docker-obsidian/releases/latest | jq -r '.tag_name')

# Compares versions
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
  echo "Update available!"
fi
```

#### `notify`
Sends notifications about updates.

**Options:**
1. **GitHub Issue** (default): Creates issue with auto-update label
2. **Email** (optional): Sends via SMTP if configured

#### `auto-release`
Automatically updates the chart.

**Modes:**

**PR Mode** (default, `AUTO_MERGE != 'true'`):
```bash
# Updates Chart.yaml
# Creates pull request for review
# Adds labels: automated, dependencies, auto-update
```

**Auto-Merge Mode** (`AUTO_MERGE = 'true'`):
```bash
# Updates Chart.yaml
# Commits directly to main
# Creates and pushes git tag
# Triggers release workflow
```

**Chart Version Bumping:**
```bash
# Increments patch version automatically
0.1.3 → 0.1.4
```

### Creating Auto-Update for Other Charts

1. Copy `auto-update-obsidian.yaml`
2. Rename to `auto-update-<chart-name>.yaml`
3. Update chart paths:
   ```yaml
   CURRENT_VERSION=$(grep '^appVersion:' charts/<chart-name>/Chart.yaml ...)
   ```
4. Change update source (Docker Hub, GitHub releases, etc.)
5. Adjust notification messages
6. Configure workflow variables

## Configuration

### Chart Testing (`.github/ct.yaml`)

```yaml
chart-dirs:
  - charts                    # Scans all subdirectories
chart-repos:
  - bitnami=https://charts.bitnami.com/bitnami  # Dependency repos
helm-extra-args: --timeout 600s
validate-maintainers: false   # Disable maintainer validation
```

### Workflow Variables and Secrets

Set in **Repository Settings → Secrets and variables → Actions**:

**Variables** (for auto-update):
- `AUTO_MERGE`: Set to `'true'` for automatic commits
- `NOTIFICATION_EMAIL`: Email for notifications
- `DISABLE_ISSUE_NOTIFICATION`: Set to `'true'` to disable issues
- `PR_REVIEWERS`: Comma-separated GitHub usernames
- `PR_MENTIONS`: Additional users to mention in PRs
- `ISSUE_ASSIGNEES`: GitHub usernames for issue assignment

**Secrets** (for email notifications):
- `MAIL_SERVER`: SMTP server address
- `MAIL_PORT`: SMTP port (default: 587)
- `MAIL_USERNAME`: SMTP username
- `MAIL_PASSWORD`: SMTP password
- `MAIL_FROM`: From email address

**Built-in**:
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

## Workflow Permissions

### `lint-test.yaml`
```yaml
permissions: read-all  # Only needs to read repository
```

### `release.yaml`
```yaml
permissions:
  contents: write          # Create releases and push to gh-pages
```

### `auto-update-obsidian.yaml`
```yaml
permissions:
  contents: write          # Update files and create tags
  pull-requests: write     # Create pull requests
  issues: write           # Create notification issues
```

## Adding Charts - CI/CD Impact

When you add a new chart to `charts/`:

### Automatic Detection
- ✅ `lint-test.yaml`: Auto-detects and tests new chart
- ✅ `release.yaml`: Auto-packages and releases on tags
- ❌ Auto-update: Requires dedicated workflow

### No Changes Needed
The generic workflows already handle multiple charts:

```bash
# These automatically loop through all charts
for chart in charts/*/; do
  helm lint "$chart"
done
```

## Testing Workflows Locally

### Install act (GitHub Actions locally)
```bash
brew install act
```

### Run lint workflow
```bash
act pull_request -W .github/workflows/lint-test.yaml
```

### Test chart-testing
```bash
# Install ct
brew install chart-testing

# Run lint
ct lint --config .github/ct.yaml --all

# Run install (requires kind)
kind create cluster
ct install --config .github/ct.yaml --all
kind delete cluster
```

## Troubleshooting

### Chart Not Released

**Symptom**: Tag pushed but chart not released

**Check:**
1. Tag format matches `v*.*.*`
2. Chart version in Chart.yaml was incremented
3. Workflow has `contents: write` permission
4. GitHub Actions enabled in repository settings

### Chart Testing Fails

**Symptom**: `ct install` fails in CI

**Common causes:**
1. Template syntax errors
2. Missing required values
3. Resource requests exceed kind cluster limits
4. Dependencies not available

**Debug:**
```bash
# Test locally with kind
kind create cluster
helm install test ./charts/my-chart
kubectl get pods
kubectl logs <pod-name>
```

### Auto-Update Not Working

**Check:**
1. Workflow file syntax (YAML)
2. Permissions configured
3. Secrets/variables set correctly
4. API rate limits not exceeded
5. Chart path correct

## Best Practices

1. **Test Before Pushing**: Run `helm lint` and `helm template` locally
2. **Version Bumping**: Always increment chart version for changes
3. **Change Detection**: CI only tests changed charts for efficiency
4. **Tag Naming**: Use `<chart-name>-v<version>` for multi-chart repos
5. **Examples**: Ensure all example files template successfully
6. **Dependencies**: Declare chart dependencies in Chart.yaml

## Resources

- [Helm Chart Testing](https://github.com/helm/chart-testing)
- [Chart Releaser Action](https://github.com/helm/chart-releaser-action)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)
