# Configuration Reference

This document provides a comprehensive reference for all configuration options available in the Obsidian Helm chart.

## Configuration Parameters

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `lscr.io/linuxserver/obsidian` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `image.tag` | Image tag (overrides appVersion) | `"latest"` |
| `imagePullSecrets` | Image pull secrets | `[]` |

### Deployment Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas (should be 1) | `1` |
| `nameOverride` | Override the name of the chart | `""` |
| `fullnameOverride` | Override the full name | `""` |
| `podAnnotations` | Annotations for pods | `{}` |

### Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `podSecurityContext.fsGroup` | Group ID for volume ownership | `1000` |
| `securityContext.runAsUser` | User ID to run container | `1000` |
| `securityContext.runAsGroup` | Group ID to run container | `1000` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.httpPort` | HTTP port | `3000` |
| `service.httpsPort` | HTTPS port (recommended) | `3001` |
| `service.annotations` | Service annotations | `{}` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable Ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts[0].host` | Hostname | `obsidian.local` |
| `ingress.hosts[0].paths[0].path` | Path | `/` |
| `ingress.hosts[0].paths[0].pathType` | Path type | `Prefix` |
| `ingress.hosts[0].paths[0].port` | Backend port | `3001` |
| `ingress.tls` | TLS configuration | `[]` |

### Persistence Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence | `true` |
| `persistence.storageClass` | Storage class name | `""` (cluster default) |
| `persistence.accessMode` | Access mode | `ReadWriteOnce` |
| `persistence.size` | Storage size | `10Gi` |
| `persistence.existingClaim` | Use existing PVC | `""` |
| `persistence.annotations` | PVC annotations | `{}` |

### Resource Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.requests.cpu` | CPU request | `500m` |
| `resources.requests.memory` | Memory request | `512Mi` |
| `resources.limits.cpu` | CPU limit | `2000m` |
| `resources.limits.memory` | Memory limit | `2Gi` |

### Health Checks

| Parameter | Description | Default |
|-----------|-------------|---------|
| `livenessProbe.httpGet.path` | Liveness probe path | `/` |
| `livenessProbe.httpGet.port` | Liveness probe port | `https` |
| `livenessProbe.initialDelaySeconds` | Initial delay | `30` |
| `readinessProbe.httpGet.path` | Readiness probe path | `/` |
| `readinessProbe.initialDelaySeconds` | Initial delay | `10` |
| `startupProbe.failureThreshold` | Startup failures allowed | `20` (200s) |

### Environment Variables

#### Core Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `env.puid` | User ID for file ownership | `"1000"` |
| `env.pgid` | Group ID for file ownership | `"1000"` |
| `env.timezone` | Timezone setting | `"Etc/UTC"` |
| `env.title` | Browser title | `"Obsidian"` |

#### Authentication

| Parameter | Description | Default |
|-----------|-------------|---------|
| `auth.enabled` | Enable basic auth | `false` |
| `auth.username` | Auth username | `""` |
| `auth.password` | Auth password | `""` |

#### Selkies Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `selkies.lcAll` | Locale setting | `""` |
| `selkies.subfolder` | Subfolder for reverse proxy | `""` |
| `selkies.encoder` | Video encoder | `"x264enc,x264enc-striped,jpeg"` |
| `selkies.framerate` | Framerate | `"8-120"` |
| `selkies.uiTitle` | UI sidebar title | `"Selkies"` |
| `selkies.uiShowLogo` | Show Selkies logo | `true` |
| `selkies.uiShowSidebar` | Show main sidebar | `true` |

#### Additional Environment Variables

| Parameter | Description | Default |
|-----------|-------------|---------|
| `extraEnv` | Additional env vars (array) | `[]` |

### Shared Memory

| Parameter | Description | Default |
|-----------|-------------|---------|
| `shmSize` | Shared memory size for Electron | `1Gi` |

### Node Assignment

| Parameter | Description | Default |
|-----------|-------------|---------|
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity rules | `{}` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `false` |
| `serviceAccount.annotations` | SA annotations | `{}` |
| `serviceAccount.name` | SA name | `""` |

## Configuration Examples

### Authentication

Enable HTTP basic authentication:

```yaml
auth:
  enabled: true
  username: "admin"
  password: "your-secure-password"
```

### Ingress with TLS

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
  hosts:
    - host: obsidian.example.com
      paths:
        - path: /
          pathType: Prefix
          port: 3001
  tls:
    - secretName: obsidian-tls
      hosts:
        - obsidian.example.com
```

### GPU Acceleration

For VAAPI (Intel/AMD):

```yaml
extraEnv:
  - name: DRINODE
    value: "/dev/dri/renderD128"
```

For NVIDIA:

```yaml
extraEnv:
  - name: NVIDIA_VISIBLE_DEVICES
    value: "all"
  - name: NVIDIA_DRIVER_CAPABILITIES
    value: "all"
```

### Custom Locale

```yaml
selkies:
  lcAll: "zh_CN.UTF-8"
```

### Subfolder Deployment

When deploying behind a reverse proxy on a subfolder:

```yaml
selkies:
  subfolder: "/obsidian/"
```

### High Performance Setup

```yaml
resources:
  requests:
    cpu: 2000m
    memory: 2Gi
  limits:
    cpu: 4000m
    memory: 4Gi

persistence:
  size: 100Gi
  storageClass: fast-ssd

shmSize: 2Gi

selkies:
  encoder: "x264enc"
  framerate: "60"
```

### Multi-user Setup with Existing Claims

For deploying multiple instances with different users:

```yaml
# User 1
fullnameOverride: "obsidian-user1"
persistence:
  existingClaim: "obsidian-user1-data"
auth:
  enabled: true
  username: "user1"
  password: "user1-password"

---
# User 2  
fullnameOverride: "obsidian-user2"
persistence:
  existingClaim: "obsidian-user2-data"
auth:
  enabled: true
  username: "user2"
  password: "user2-password"
```

## Security

### Best Practices

1. **Always enable authentication** for production deployments:
   ```yaml
   auth:
     enabled: true
     username: "admin"
     password: "strong-random-password"
   ```

2. **Use HTTPS** (port 3001) - required for WebCodecs support

3. **Use Ingress with valid TLS certificates** for external access

4. **Limit resources** to prevent resource exhaustion:
   ```yaml
   resources:
     limits:
       cpu: 2000m
       memory: 2Gi
   ```

5. **Use network policies** to restrict access (not configured by chart)

### Important Security Notes

- The container provides privileged desktop access
- Terminal has passwordless sudo access
- Do not expose to the Internet without proper security
- Basic auth is only suitable for trusted networks
- Use OAuth2 proxy or similar for production external access

## Selkies Advanced Configuration

For complete Selkies options, see the [baseimage-selkies documentation](https://github.com/linuxserver/docker-baseimage-selkies).

Common additional options via `extraEnv`:

```yaml
extraEnv:
  # Audio support
  - name: SELKIES_AUDIO_ENABLED
    value: "true"
  
  # Gamepad support
  - name: SELKIES_GAMEPAD_ENABLED
    value: "true"
  
  # Custom port
  - name: CUSTOM_HTTPS_PORT
    value: "3001"
  
  # IPv6 disable
  - name: DISABLE_IPV6
    value: "true"
  
  # Harden desktop security
  - name: HARDEN_DESKTOP
    value: "true"
```

## Troubleshooting Configuration Issues

See [Troubleshooting Guide](troubleshooting.md) for common configuration issues and solutions.
