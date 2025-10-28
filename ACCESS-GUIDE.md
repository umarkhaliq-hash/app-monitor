# 🚀 Access Your Services

## **Service Ports (NodePort):**

### **Jenkins CI:**
```bash
kubectl port-forward svc/jenkins 8080:8080 -n dev-jenkins
# OR use NodePort: http://localhost:31759
```

### **PrestaShop App:**
```bash
kubectl port-forward svc/prestashop 3080:80 -n dev-prestashop
# OR use NodePort: http://localhost:30297
# Open: http://localhost:3080
```

### **Spinnaker CD:**
```bash
kubectl port-forward svc/spinnaker-light 9000:80 -n dev-spinnaker
# OR use NodePort: http://localhost:32627
```

### **Grafana Monitoring:**
```bash
kubectl port-forward svc/grafana 3000:3000 -n dev-monitoring
# OR use NodePort: http://localhost:31465
```

## **PrestaShop Database Setup:**
If you see setup page, use:
- **Database server**: `mysql`
- **Database name**: `prestashop`
- **Database login**: `root`
- **Database password**: `root`

## **Complete Workflow:**
1. **Jenkins** (port 8080): CI builds
2. **Spinnaker** (port 9000): CD deploys
3. **PrestaShop** (port 3080): Your app
4. **Grafana** (port 3000): Monitoring