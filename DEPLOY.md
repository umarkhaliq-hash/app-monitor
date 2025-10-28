# Terraform Deployment Guide

## 1. Start Minikube
```bash
minikube start
```

## 2. Deploy Everything with Terraform
```bash
cd terraform
terraform init
terraform apply
```

## 3. Destroy Everything
```bash
terraform destroy
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