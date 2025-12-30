# Contributing to Obsidian Helm Chart

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

- Check if the issue already exists in [GitHub Issues](https://github.com/thinking-and-coding/obsidian-helm-chart/issues)
- Provide detailed information:
  - Helm version
  - Kubernetes version
  - Chart version
  - Error messages and logs
  - Steps to reproduce
  - Expected vs actual behavior

### Suggesting Enhancements

- Open an issue with the label "enhancement"
- Describe the feature and its use case
- Explain how it would benefit users

### Pull Requests

1. **Fork the repository**

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Update documentation if needed
   - Add examples if applicable
   - Test your changes

4. **Test your changes**
   ```bash
   # Lint the chart
   helm lint charts/obsidian/
   
   # Template with different configurations
   helm template test charts/obsidian/
   helm template test charts/obsidian/ -f examples/values-production.yaml
   
   # Test installation (if possible)
   helm install test charts/obsidian/ --dry-run --debug
   ```

5. **Update version numbers** (if applicable)
   - Bump `version` in `charts/obsidian/Chart.yaml`
   - Follow [Semantic Versioning](https://semver.org/)
   - Update `appVersion` if upgrading Obsidian version

6. **Update documentation**
   - Update README.md if adding features
   - Update docs/ if changing configuration
   - Add examples if adding new features
   - Update CHANGELOG (if exists)

7. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add support for X"
   ```
   
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` - New features
   - `fix:` - Bug fixes
   - `docs:` - Documentation changes
   - `refactor:` - Code refactoring
   - `test:` - Test changes
   - `chore:` - Maintenance tasks

8. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub

## Development Setup

### Prerequisites

- Helm 3.2.0+
- Kubernetes cluster (for testing)
- kubectl
- Git

### Local Development

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/obsidian-helm-chart.git
cd helm-charts

# Add upstream remote
git remote add upstream https://github.com/thinking-and-coding/obsidian-helm-chart.git

# Create feature branch
git checkout -b feature/my-feature

# Make changes and test
helm lint charts/obsidian/
helm template test charts/obsidian/

# Commit and push
git add .
git commit -m "feat: my new feature"
git push origin feature/my-feature
```

## Chart Guidelines

### Structure

- Keep templates simple and readable
- Use helpers (`_helpers.tpl`) for repeated logic
- Follow Helm best practices
- Use meaningful variable names
- Add comments for complex logic

### Values

- Provide sensible defaults
- Document all values in comments
- Group related values together
- Use camelCase for value names
- Mark deprecated values clearly

### Documentation

- Update README.md for user-facing changes
- Update docs/ for detailed configuration
- Add examples for new features
- Keep documentation clear and concise

### Testing

All PRs should:
- Pass linting (`helm lint`)
- Template successfully
- Include tests when adding features
- Not break existing functionality

## Release Process

Releases are automated via GitHub Actions:

1. Merge PR to `main`
2. Update chart version in `Chart.yaml`
3. Create and push tag:
   ```bash
   git tag v0.2.0
   git push origin v0.2.0
   ```
4. GitHub Actions will:
   - Run tests
   - Package chart
   - Update gh-pages branch
   - Create GitHub Release

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions

## Questions?

- Open a [Discussion](https://github.com/thinking-and-coding/obsidian-helm-chart/discussions)
- Ask in an [Issue](https://github.com/thinking-and-coding/obsidian-helm-chart/issues)
- Review existing [Pull Requests](https://github.com/thinking-and-coding/obsidian-helm-chart/pulls)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
