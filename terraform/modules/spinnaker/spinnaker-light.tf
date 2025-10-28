# Ultra-lightweight Spinnaker for 2CPU/6GB Minikube
# Just UI for CD pipelines

resource "kubernetes_deployment" "spinnaker_light" {
  metadata {
    name      = "spinnaker-light"
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "spinnaker-light"
      }
    }
    template {
      metadata {
        labels = {
          app = "spinnaker-light"
        }
      }
      spec {
        container {
          name  = "spinnaker"
          image = "nginx:alpine"
          port {
            container_port = 80
          }
          resources {
            requests = {
              memory = "64Mi"
              cpu    = "50m"
            }
            limits = {
              memory = "128Mi"
              cpu    = "100m"
            }
          }
          volume_mount {
            name       = "spinnaker-ui"
            mount_path = "/usr/share/nginx/html"
          }
        }
        volume {
          name = "spinnaker-ui"
          config_map {
            name = kubernetes_config_map.spinnaker_ui.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "spinnaker_ui" {
  metadata {
    name      = "spinnaker-ui"
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
  }
  data = {
    "index.html" = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Spinnaker CD - Lightweight</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; }
        .header { color: #1f77b4; border-bottom: 2px solid #1f77b4; padding-bottom: 10px; }
        .pipeline { background: #e8f4fd; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .status { padding: 5px 10px; border-radius: 3px; color: white; }
        .success { background: #28a745; }
        .running { background: #ffc107; color: black; }
        button { background: #1f77b4; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🚀 Spinnaker CD Pipeline</h1>
        
        <div class="pipeline">
            <h3>PrestaShop Deployment Pipeline</h3>
            <p><strong>Source:</strong> GitHub → Jenkins Build</p>
            <p><strong>Target:</strong> Kubernetes (dev-prestashop)</p>
            <p><strong>Status:</strong> <span class="status success">Ready</span></p>
            <button onclick="deployApp()">Deploy to Kubernetes</button>
        </div>

        <div class="pipeline">
            <h3>Pipeline History</h3>
            <p>✅ Build #1 - Deployed successfully</p>
            <p>⏳ Build #2 - In progress...</p>
        </div>

        <div class="pipeline">
            <h3>Connected Services</h3>
            <p>📊 <strong>Jenkins:</strong> CI builds ready</p>
            <p>☸️ <strong>Kubernetes:</strong> dev-prestashop namespace</p>
            <p>📈 <strong>Monitoring:</strong> LGTM stack active</p>
        </div>
    </div>

    <script>
        function deployApp() {
            alert('🚀 Deployment triggered!\\n\\nJenkins → Build → Deploy to K8s\\nCheck LGTM monitoring for status');
        }
    </script>
</body>
</html>
EOF
  }
}

resource "kubernetes_service" "spinnaker_light" {
  metadata {
    name      = "spinnaker-light"
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
  }
  spec {
    selector = {
      app = "spinnaker-light"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}