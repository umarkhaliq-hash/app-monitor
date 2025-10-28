#!/bin/bash
echo " Spinnaker CD: Deploying PrestaShop..."

# Deploy PrestaShop application
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prestashop
  namespace: dev-prestashop
  labels:
    app: prestashop
    deployed-by: spinnaker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prestashop
  template:
    metadata:
      labels:
        app: prestashop
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "80"
    spec:
      containers:
      - name: prestashop
        image: prestashop/prestashop:8.1-apache
        ports:
        - containerPort: 80
        env:
        - name: DB_SERVER
          value: "mysql.dev-prestashop.svc.cluster.local"
        - name: DB_NAME
          value: "prestashop"
        - name: DB_USER
          value: "root"
        - name: DB_PASSWD
          value: "root"
        - name: PS_INSTALL_AUTO
          value: "1"
        - name: PS_DOMAIN
          value: "localhost:8090"
        - name: PS_FOLDER_ADMIN
          value: "admin"
        - name: PS_FOLDER_INSTALL
          value: "install"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: dev-prestashop
  labels:
    app: mysql
    deployed-by: spinnaker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "root"
        - name: MYSQL_DATABASE
          value: "prestashop"
        - name: MYSQL_USER
          value: "prestashop"
        - name: MYSQL_PASSWORD
          value: "prestashop"
EOF

echo " PrestaShop deployed successfully!"
echo " Check status: kubectl get pods -n dev-prestashop"

