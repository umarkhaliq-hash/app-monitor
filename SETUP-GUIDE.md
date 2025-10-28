# Complete Setup Guide

## 1. Jenkins GitHub Integration

### Step 1: Access Jenkins
```bash
kubectl port-forward svc/jenkins 8080:8080 -n dev-jenkins
# Open http://localhost:8080
```

### Step 2: Get Jenkins Admin Password
```bash
kubectl exec -it deployment/jenkins -n dev-jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
```

### Step 3: Create GitHub Job
1. Click "New Item"
2. Enter name: "prestashop-ci"
3. Select "Freestyle project"
4. In Source Code Management:
   - Select "Git"
   - Repository URL: `https://github.com/umarkhaliq-hash/app-monitor.git`
   - Branch: `*/main`
5. In Build Triggers:
   - Check "GitHub hook trigger for GITScm polling"
6. In Build Steps:
   - Add "Execute shell"
   - Copy script from `jenkins/jenkins-github-job.xml`

## 2. Grafana Setup

### Step 1: Access Grafana
```bash
kubectl port-forward svc/grafana 3000:3000 -n dev-monitoring
# Open http://localhost:3000
# Login: admin/admin
```

### Step 2: Add Datasources
1. Go to Connections → Data sources
2. Add Loki:
   - URL: `http://loki.dev-monitoring.svc.cluster.local:3100`
3. Add Mimir (Prometheus):
   - URL: `http://mimir.dev-monitoring.svc.cluster.local:8080`
4. Add Tempo:
   - URL: `http://tempo.dev-monitoring.svc.cluster.local:3200`

### Step 3: Import Dashboard
1. Go to Dashboards → Import
2. Upload `monitoring/prestashop-dashboard.json`
3. Select datasources and import

## 3. Spinnaker Usage

### Access Spinnaker
```bash
kubectl port-forward svc/spinnaker-light 9000:80 -n dev-spinnaker
# Open http://localhost:9000
```

### Create Deployment Pipeline
1. Click "Deploy to Kubernetes" button
2. This triggers deployment to dev-prestashop namespace
3. Monitor progress in LGTM stack

## 4. Complete Workflow

1. **Code Changes** → Push to GitHub
2. **Jenkins** → Automatically builds (webhook)
3. **Spinnaker** → Deploy via UI button
4. **Grafana** → Monitor everything

## 5. Monitoring Dashboard Features

- **Pod Status**: PrestaShop, Jenkins, Spinnaker, MySQL
- **CPU Usage**: Real-time per pod
- **Memory Usage**: Current consumption
- **CPU/Memory %**: Gauge charts
- **Kubernetes Overview**: Cluster status
- **Application Logs**: Live log streaming

Your complete CI/CD infrastructure is ready! 🚀