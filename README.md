# Obsidian Helm Chart

Helm chart for deploying [LinuxServer.io Obsidian](https://github.com/linuxserver/docker-obsidian) on Kubernetes with web-based GUI using Selkies.

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/obsidian)](https://artifacthub.io/packages/search?repo=obsidian)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Features

- 🚀 Easy deployment with sensible defaults
- 🔒 Optional authentication and security settings
- 💾 Persistent storage with PVC support
- 🌐 Ingress support with TLS
- 🎛️ Comprehensive configuration options
- 📊 Resource limits and health checks
- 🖥️ GPU acceleration support (VAAPI, NVIDIA)
- 🔄 Automated deployment strategy for stateful applications

## Quick Start

### Using Helm Repository (Recommended)

```bash
# Add the Helm repository
helm repo add obsidian https://thinking-and-coding.github.io/obsidian-helm-chart
helm repo update

# Install the chart
helm install my-obsidian obsidian/obsidian

# Access the application
kubectl port-forward svc/my-obsidian-obsidian 3001:3001
# Visit https://localhost:3001
```

### Using Git Repository

```bash
# Clone the repository
git clone https://github.com/thinking-and-coding/obsidian-helm-chart.git
cd obsidian-helm-chart

# Install the chart
helm install my-obsidian ./charts/obsidian

# Or with custom values
helm install my-obsidian ./charts/obsidian -f examples/values-production.yaml
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (for persistence)
- Sufficient cluster resources (500m CPU, 512Mi RAM minimum)

## Configuration

See [Configuration Guide](docs/configuration.md) for detailed configuration options.

### Common Configurations

#### Enable Authentication

```bash
helm install my-obsidian obsidian/obsidian \
  --set auth.enabled=true \
  --set auth.username=admin \
  --set auth.password=your-secure-password
```

#### With Ingress and TLS

```bash
helm install my-obsidian obsidian/obsidian \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=obsidian.example.com \
  --set ingress.className=nginx \
  --set ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod
```

#### Custom Resources

```bash
helm install my-obsidian obsidian/obsidian \
  --set resources.limits.cpu=4000m \
  --set resources.limits.memory=4Gi \
  --set persistence.size=50Gi \
  --set persistence.storageClass=fast-ssd
```

#### GPU Acceleration

```bash
helm install my-obsidian obsidian/obsidian \
  --set extraEnv[0].name=DRINODE \
  --set extraEnv[0].value=/dev/dri/renderD128
```

## Examples

Check the [examples/](examples/) directory for complete configuration examples:

- [Basic Setup](examples/values-basic.yaml) - Minimal configuration with defaults
- [Production Setup](examples/values-production.yaml) - Production-ready with auth and resources
- [Ingress with TLS](examples/values-with-ingress.yaml) - External access with SSL
- [GPU Acceleration](examples/values-gpu.yaml) - Hardware acceleration for better performance

## Documentation

- [Installation Guide](docs/installation.md) - Step-by-step installation instructions
- [Configuration Reference](docs/configuration.md) - Complete parameter reference
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Upgrade Guide](docs/upgrade.md) - Version upgrade instructions
- [Auto-Update Setup](docs/auto-update.md) - Automated version tracking and releases

## Key Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas (should be 1 for stateful apps) | `1` |
| `image.repository` | Container image repository | `lscr.io/linuxserver/obsidian` |
| `image.tag` | Container image tag | `latest` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.size` | Storage size | `10Gi` |
| `auth.enabled` | Enable HTTP basic authentication | `false` |
| `ingress.enabled` | Enable Ingress resource | `false` |
| `resources.requests.cpu` | CPU resource requests | `500m` |
| `resources.requests.memory` | Memory resource requests | `512Mi` |

For a complete list of parameters, see [values.yaml](charts/obsidian/values.yaml) or the [Configuration Reference](docs/configuration.md).

## Uninstalling

```bash
# Uninstall the release
helm uninstall my-obsidian

# Optionally, delete the PVC (this will delete all your data!)
kubectl delete pvc my-obsidian-obsidian-config
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

If you encounter any issues or have questions:

- Check the [Troubleshooting Guide](docs/troubleshooting.md)
- Open an issue on [GitHub](https://github.com/thinking-and-coding/obsidian-helm-chart/issues)
- Refer to the [LinuxServer.io Obsidian documentation](https://docs.linuxserver.io/images/docker-obsidian)

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Based on [LinuxServer.io Obsidian Docker container](https://github.com/linuxserver/docker-obsidian)
- Uses [Selkies](https://github.com/selkies-project/selkies-gstreamer) for web desktop streaming
- Built on [Kubernetes](https://kubernetes.io/) and [Helm](https://helm.sh/)

## Security

> [!WARNING]
> This container provides privileged access to a desktop environment. Do not expose it to the Internet without proper authentication and security measures.

- HTTPS is **required** for full functionality (WebCodecs support)
- The default self-signed certificate is only suitable for local development
- For production, use a reverse proxy with valid TLS certificates
- Enable authentication (`auth.enabled=true`) or use external authentication via Ingress
- The web interface includes a terminal with sudo access
