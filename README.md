# PrestaShop Multi-Cloud Infrastructure

Simple multi-cloud setup for PrestaShop with CI/CD and monitoring.

## Architecture
- **App**: PrestaShop e-commerce
- **CI**: Jenkins 
- **CD**: Spinnaker
- **Deploy**: Local Minikube
- **Monitor**: LGTM Stack (Loki, Grafana, Tempo, Mimir)

## Quick Start
```bash
# 1. Start Minikube
minikube start

# 2. Deploy infrastructure
terraform init && terraform apply

# 3. Setup CI/CD
kubectl apply -f jenkins/
kubectl apply -f spinnaker/

# 4. Deploy monitoring
kubectl apply -f monitoring/

# 5. Deploy app
kubectl apply -f k8s/
```

## Structure
```
├── prestashop/          # PrestaShop app
├── terraform/           # Infrastructure
├── jenkins/            # CI pipeline
├── spinnaker/          # CD pipeline
├── monitoring/         # LGTM stack
└── k8s/               # K8s manifests
```