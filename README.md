# Grafana Demo Services

This Helm chart deploys three dummy services in a Kubernetes cluster for demonstrating Grafana Cloud observability features. The services use NGINX to simulate different API behaviors and demonstrate distributed tracing, metrics, and logging with Alloy.

## Services Overview

### Service A - Fast Endpoint
- **Image**: `nginx:alpine`
- **Endpoint**: `GET /fast`
- **Behavior**: Returns mock JSON data immediately
- **Purpose**: Demonstrates a fast, healthy service response
- **Port**: 80

### Service B - Slow Endpoint (Internal Call)
- **Image**: `nginx:alpine`
- **Endpoint**: `GET /slow`
- **Behavior**: Makes an internal call to Service A's `/fast` endpoint
- **Purpose**: Demonstrates service-to-service communication and distributed tracing within the cluster
- **Port**: 80

### Service C - External Endpoint
- **Image**: `nginx:alpine`
- **Endpoint**: `GET /external`
- **Behavior**: Makes a call to a public API (jsonplaceholder.typicode.com)
- **Purpose**: Demonstrates external API calls and tracing requests outside the cluster
- **Port**: 80

All services include a `/health` endpoint for health checks.

## Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.x installed
- Alloy installed in the cluster for sending metrics, traces, and logs to Grafana Cloud

## Installation

### Install the chart with default values:

```bash
helm install grafana-demo-services ./grafana-demo-services
```

### Install with custom namespace:

```bash
helm install grafana-demo-services ./grafana-demo-services --namespace demo --create-namespace
```

### Install with custom values:

```bash
helm install grafana-demo-services ./grafana-demo-services -f custom-values.yaml
```

## Testing the Services

Once deployed, you can test the endpoints using `kubectl port-forward`:

### Test Service A (Fast Response):
```bash
kubectl port-forward svc/service-a 8080:80
curl http://localhost:8080/fast
```

### Test Service B (Internal Call to Service A):
```bash
kubectl port-forward svc/service-b 8081:80
curl http://localhost:8081/slow
```

### Test Service C (External API Call):
```bash
kubectl port-forward svc/service-c 8082:80
curl http://localhost:8082/external
```

## Configuration

The following table lists the configurable parameters:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceA.name` | Name of service A | `service-a` |
| `serviceA.image` | Docker image for service A | `nginx:alpine` |
| `serviceA.replicas` | Number of replicas | `2` |
| `serviceA.port` | Service port | `80` |
| `serviceB.name` | Name of service B | `service-b` |
| `serviceB.image` | Docker image for service B | `nginx:alpine` |
| `serviceB.replicas` | Number of replicas | `2` |
| `serviceB.serviceAUrl` | URL to call service A | `http://service-a/fast` |
| `serviceC.name` | Name of service C | `service-c` |
| `serviceC.image` | Docker image for service C | `nginx:alpine` |
| `serviceC.replicas` | Number of replicas | `2` |
| `serviceC.externalApiUrl` | External API URL | `https://jsonplaceholder.typicode.com/posts/1` |
| `resources.requests.cpu` | CPU request | `50m` |
| `resources.requests.memory` | Memory request | `64Mi` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `128Mi` |

## Grafana Cloud Integration

These services are designed to work with Alloy for observability:

### Metrics
- Prometheus annotations are included in the pod specs
- NGINX access logs provide request metrics

### Traces
- Service B → Service A calls demonstrate internal tracing
- Service C → External API calls demonstrate external tracing
- Custom headers (X-Service-Name, X-Response-Type) aid in trace correlation

### Logs
- NGINX access and error logs are written to stdout/stderr
- Alloy can collect these logs and send them to Loki

## Uninstallation

To uninstall the chart:

```bash
helm uninstall grafana-demo-services
```

To delete the namespace:

```bash
kubectl delete namespace demo
```

## Troubleshooting

### Check pod status:
```bash
kubectl get pods -l app=service-a
kubectl get pods -l app=service-b
kubectl get pods -l app=service-c
```

### View logs:
```bash
kubectl logs -l app=service-a
kubectl logs -l app=service-b
kubectl logs -l app=service-c
```

### Check service endpoints:
```bash
kubectl get endpoints
```

## License

This chart is provided as-is for demonstration purposes.