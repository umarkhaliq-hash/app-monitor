#!/bin/bash
echo "Spinnaker CD: Deploying PrestaShop to Minikube..."
echo "Checking Jenkins Build Artifacts..."

# Get Jenkins build artifact from latest build
BUILD_ARTIFACT=$(kubectl exec -n dev-jenkins deployment/jenkins -- cat /var/jenkins_home/jobs/webapp/builds/2/archive/deploy-trigger.txt 2>/dev/null || echo "No artifact found")
echo " Jenkins Artifact Found: $BUILD_ARTIFACT"

# Get Jenkins-built deployment YAML from latest build
echo " Retrieving Jenkins-built deployment YAML..."
kubectl exec -n dev-jenkins deployment/jenkins -- cat /var/jenkins_home/jobs/webapp/builds/2/archive/prestashop-deployment.yaml > /tmp/jenkins-deployment.yaml

if [ -f "/tmp/jenkins-deployment.yaml" ]; then
    echo " Using Jenkins-generated deployment from $BUILD_ARTIFACT"
    kubectl apply -f /tmp/jenkins-deployment.yaml
    rm /tmp/jenkins-deployment.yaml
else
    echo " Jenkins deployment YAML not found, using fallback"
    kubectl apply -f spinnaker/deploy-prestashop.yaml
fi

echo " PrestaShop deployment triggered!"
echo " Check status: kubectl get pods -n dev-prestashop"
echo " Access app: kubectl port-forward svc/prestashop 8090:80 -n dev-prestashop"