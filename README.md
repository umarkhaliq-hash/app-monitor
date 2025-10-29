# PrestaShop Multi-Cloud Infrastructure

Complete CI/CD pipeline with live monitoring on Minikube.

## Quick Start
```bash
# 1. Start cluster
minikube start

# 2. Deploy everything
cd terraform && terraform init && terraform apply -auto-approve

# 3. Access services
kubectl port-forward svc/grafana 3000:3000 -n dev-monitoring &
kubectl port-forward svc/prestashop 3080:80 -n dev-prestashop &
kubectl port-forward svc/jenkins 8080:8080 -n dev-jenkins &
kubectl port-forward svc/spinnaker-light 9000:80 -n dev-spinnaker &
```

## Services
- **PrestaShop**: http://localhost:3080 (E-commerce app)
- **Grafana**: http://localhost:3000 (Live monitoring dashboard)
- **Jenkins**: http://localhost:8080 (CI pipeline)
- **Spinnaker**: http://localhost:9000 (CD deployment)

## Architecture
- **Application**: PrestaShop e-commerce with MySQL
- **CI Pipeline**: Jenkins for continuous integration
- **CD Pipeline**: Spinnaker for continuous deployment
- **Monitoring**: LGTM stack (Loki, Grafana, Tempo, Mimir, Prometheus)
- **Infrastructure**: Minikube Kubernetes cluster
- **IaC**: Terraform for infrastructure as code

## Project Structure
```
app-monitor/
├── terraform/
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output values
│   └── modules/
│       ├── prestashop/         # PrestaShop app module
│       ├── jenkins/            # Jenkins CI module
│       ├── spinnaker/          # Spinnaker CD module
│       └── monitoring/         # LGTM monitoring stack
└── monitoring/
    └── prestashop-dashboard.json  # Grafana dashboard config
```

## Features
- **Live Pod Monitoring** - Real-time pod status tracking  
- **CPU/Memory Metrics** - Live resource usage monitoring  
- **Auto-Discovery** - Automatic service detection  
- **Failure Detection** - Instant pod failure alerts  
- **5-Second Refresh** - Real-time dashboard updates  
- **Multi-Namespace** - Organized service deployment  
- **RBAC Security** - Proper Kubernetes permissions  
- **Infrastructure as Code** - Terraform automation  

## Monitoring Stack (LGTM)
- **Loki**: Log aggregation
- **Grafana**: Visualization and dashboards
- **Tempo**: Distributed tracing
- **Mimir**: Long-term metrics storage
- **Prometheus**: Metrics collection
- **Promtail**: Log shipping
- **kube-state-metrics**: Kubernetes metrics
- **node-exporter**: Node metrics

## Database Setup
If PrestaShop shows setup page:
- **Database server**: `mysql`
- **Database name**: `prestashop`
- **Username**: `root`
- **Password**: `root`

## Testing Live Monitoring
```bash
# Scale down Jenkins to test failure detection
kubectl scale deployment jenkins --replicas=0 -n dev-jenkins

# Watch dashboard show Jenkins as 0 pods (RED)
# Scale back up
kubectl scale deployment jenkins --replicas=1 -n dev-jenkins
```

## Cleanup
```bash
# Destroy infrastructure
cd terraform && terraform destroy -auto-approve

# Stop Minikube
minikube stop
```