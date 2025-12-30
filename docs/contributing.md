# Contributing to Helm Charts

Thank you for your interest in contributing! This guide will help you add new charts or improve existing ones.

## Repository Structure

This is a multi-chart Helm repository. Each chart is self-contained in its own directory under `charts/`:

```
helm-charts/
├── charts/
│   ├── obsidian/              # Individual chart directory
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── README.md          # Chart-specific documentation
│   │   ├── templates/
│   │   ├── examples/          # Chart-specific examples
│   │   └── docs/              # Chart-specific detailed docs
│   └── [your-chart]/          # Your new chart
├── docs/                      # Shared documentation (this directory)
└── .github/
    └── workflows/             # CI/CD pipelines
```

## Adding a New Chart

### 1. Create Chart Directory

```bash
# Create the chart skeleton
helm create charts/my-chart

# Create additional directories
mkdir -p charts/my-chart/examples
mkdir -p charts/my-chart/docs
```

### 2. Essential Files

Each chart must have:

- **Chart.yaml**: Chart metadata (name, version, description)
- **values.yaml**: Default configuration values
- **README.md**: Chart documentation with installation and usage
- **templates/**: Kubernetes resource templates
- **examples/**: At least one example values file (e.g., `values-production.yaml`)

### 3. Chart Documentation

Create comprehensive documentation in `charts/my-chart/README.md`:

- Overview and features
- Prerequisites
- Installation instructions
- Configuration parameters
- Examples
- Upgrading guide
- Troubleshooting

Optional detailed docs in `charts/my-chart/docs/`:
- `configuration.md`: Detailed parameter reference
- `installation.md`: Step-by-step installation
- `troubleshooting.md`: Common issues and solutions
- `upgrade.md`: Version upgrade guide

### 4. Examples

Provide example values files in `charts/my-chart/examples/`:

- `values-basic.yaml`: Minimal configuration
- `values-production.yaml`: Production-ready setup
- Additional examples for common use cases

### 5. Testing

Before submitting:

```bash
# Lint the chart
helm lint charts/my-chart/

# Template with default values
helm template test charts/my-chart/

# Template with example files
helm template test charts/my-chart/ -f charts/my-chart/examples/values-production.yaml

# Run chart-testing (requires chart changes compared to main branch)
ct lint --config .github/ct.yaml --all
ct install --config .github/ct.yaml --all
```

### 6. CI/CD Integration

The CI/CD pipelines automatically:

- **Lint**: Validates chart syntax and best practices
- **Test**: Templates charts with all example files
- **Release**: Packages and publishes charts on git tags

No workflow changes needed - they detect all charts automatically!

### 7. Auto-Update (Optional)

If your chart tracks an external application:

1. Create `.github/workflows/auto-update-<chart-name>.yaml`
2. Base it on `auto-update-obsidian.yaml`
3. Adjust the source and update logic
4. Update `scripts/setup-auto-update.sh` to support your chart

## Improving Existing Charts

### Making Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Update chart version in `Chart.yaml`:
   - Patch: Bug fixes (0.1.2 → 0.1.3)
   - Minor: New features, backwards compatible (0.1.3 → 0.2.0)
   - Major: Breaking changes (0.2.0 → 1.0.0)
5. Update `CHANGELOG.md` or document changes in commit message
6. Test thoroughly
7. Submit a pull request

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

Examples:
```
feat(obsidian): add support for custom environment variables

fix(obsidian): correct ingress path configuration

docs(obsidian): update installation guide for v2.0

chore(ci): improve chart-testing workflow
```

## Release Process

### Versioning

- Charts follow [Semantic Versioning](https://semver.org/)
- Each chart has independent versioning
- `appVersion` tracks the application version, not the chart version

### Creating a Release

1. Update chart version in `charts/<name>/Chart.yaml`
2. Commit changes following conventional commits
3. Create and push a git tag:
   ```bash
   git tag -a obsidian-v0.2.0 -m "Release obsidian chart v0.2.0"
   git push origin obsidian-v0.2.0
   ```
4. GitHub Actions automatically packages and publishes the chart

### Tag Naming Convention

- Single chart: `v0.2.0` or `obsidian-v0.2.0`
- Multiple charts: `<chart-name>-v<version>` (recommended)

## Chart Best Practices

### Templates

- Use `_helpers.tpl` for common template functions
- Follow Kubernetes API conventions
- Support common parameters (replicas, resources, affinity, etc.)
- Include resource limits and requests
- Add proper labels and annotations

### Values

- Provide sensible defaults
- Document all parameters in comments
- Group related settings
- Use nested structures for clarity

### Documentation

- Keep README.md up-to-date
- Include configuration examples
- Document breaking changes
- Provide upgrade instructions

### Security

- Don't hardcode secrets
- Support Kubernetes secrets
- Use least privilege principles
- Document security considerations

## Testing Requirements

All charts must pass:

1. **Helm Lint**: `helm lint charts/<name>/`
2. **Chart Testing Lint**: `ct lint --config .github/ct.yaml`
3. **Template Rendering**: All examples must template successfully
4. **Chart Testing Install** (in CI): Actual deployment test

## Getting Help

- Check existing charts for examples (especially `charts/obsidian/`)
- Review [Helm best practices](https://helm.sh/docs/chart_best_practices/)
- Ask questions in GitHub issues or discussions
- Refer to [repository structure guide](repository-structure.md)

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn
- Focus on what's best for the community

Thank you for contributing! 🎉
