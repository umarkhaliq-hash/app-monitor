#!/bin/bash
echo "🚀 Spinnaker CD: Deploying PrestaShop to Minikube..."

# Deploy PrestaShop and MySQL
kubectl apply -f spinnaker/deploy-prestashop.yaml

echo "✅ PrestaShop deployment triggered!"
echo "📊 Check status: kubectl get pods -n dev-prestashop"
echo "🌐 Access app: kubectl port-forward svc/prestashop 8080:80 -n dev-prestashop"