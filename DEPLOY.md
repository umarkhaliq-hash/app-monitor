# Manual Deployment Guide

## 1. Start Minikube
```bash
minikube start
```

## 2. Deploy Infrastructure (Terraform)
```bash
cd terraform
terraform init
terraform apply
```

## 3. Deploy Jenkins with Persistent Storage
```bash
kubectl apply -f jenkins/jenkins-pvc.yaml
kubectl apply -f jenkins/jenkins.yaml
```

## 4. Deploy Spinnaker with Persistent Storage
```bash
kubectl apply -f spinnaker/spinnaker-pvc.yaml
kubectl apply -f spinnaker/spinnaker.yaml
```

## 5. Deploy LGTM Monitoring Stack
```bash
kubectl apply -f monitoring/lgtm-stack.yaml
```

## 6. Deploy PrestaShop App
```bash
kubectl apply -f k8s/prestashop.yaml
```

## 7. Access Services
```bash
# Jenkins
minikube service jenkins -n dev-jenkins

# Spinnaker
minikube service spinnaker-deck -n dev-spinnaker

# LGTM Stack
minikube service grafana -n dev-monitoring  # Dashboards
kubectl port-forward svc/loki 3100:3100 -n dev-monitoring     # Logs
kubectl port-forward svc/mimir 8080:8080 -n dev-monitoring    # Metrics  
kubectl port-forward svc/tempo 3200:3200 -n dev-monitoring    # Traces

# PrestaShop
minikube service prestashop -n dev-prestashop
```

## Workflow
1. **Jenkins CI**: Connect to GitHub, build on commits
2. **Spinnaker CD**: Deploy from Jenkins artifacts
3. **LGTM Stack**: Monitor app performance in Grafana
4. **Persistent Data**: Jenkins & Spinnaker data survives restarts