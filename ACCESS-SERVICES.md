# 🚀 Access Your Services - Correct Ports

## **Use Different Ports to Avoid Conflicts:**

### **Jenkins CI:**
```bash
kubectl port-forward svc/jenkins 8080:8080 -n dev-jenkins
# Open: http://localhost:8080
```

### **PrestaShop App:**
```bash
kubectl port-forward svc/prestashop 8090:80 -n dev-prestashop
# Open: http://localhost:8090
```

### **Spinnaker CD:**
```bash
kubectl port-forward svc/spinnaker-light 9000:80 -n dev-spinnaker
# Open: http://localhost:9000
```

### **Grafana Monitoring:**
```bash
kubectl port-forward svc/grafana 3000:3000 -n dev-monitoring
# Open: http://localhost:3000
```

## **Access PrestaShop:**
```bash
kubectl port-forward svc/prestashop 8090:80 -n dev-prestashop
```
**Then open: http://localhost:8090**

## **PrestaShop Database Setup:**
- **Database server**: `mysql`
- **Database name**: `prestashop` 
- **Database login**: `root`
- **Database password**: `root`