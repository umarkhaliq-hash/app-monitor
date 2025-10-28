resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "grafana"
      }
    }
    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }
      spec {
        container {
          name  = "grafana"
          image = "grafana/grafana:latest"
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "loki"
      }
    }
    template {
      metadata {
        labels = {
          app = "loki"
        }
      }
      spec {
        container {
          name  = "loki"
          image = "grafana/loki:latest"
          port {
            container_port = 3100
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      app = "grafana"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "NodePort"
  }
}

resource "kubernetes_deployment" "mimir" {
  metadata {
    name      = "mimir"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mimir"
      }
    }
    template {
      metadata {
        labels = {
          app = "mimir"
        }
      }
      spec {
        container {
          name  = "mimir"
          image = "grafana/mimir:latest"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "tempo" {
  metadata {
    name      = "tempo"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "tempo"
      }
    }
    template {
      metadata {
        labels = {
          app = "tempo"
        }
      }
      spec {
        container {
          name  = "tempo"
          image = "grafana/tempo:latest"
          port {
            container_port = 3200
          }
          args = ["-config.file=/etc/tempo.yaml"]
          volume_mount {
            name       = "tempo-config"
            mount_path = "/etc/tempo.yaml"
            sub_path   = "tempo.yaml"
          }
        }
        volume {
          name = "tempo-config"
          config_map {
            name = kubernetes_config_map.tempo.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "tempo" {
  metadata {
    name      = "tempo-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  data = {
    "tempo.yaml" = <<EOF
server:
  http_listen_port: 3200
distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
storage:
  trace:
    backend: local
    local:
      path: /tmp/tempo/traces
EOF
  }
}

resource "kubernetes_service" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      app = "loki"
    }
    port {
      port        = 3100
      target_port = 3100
    }
  }
}

resource "kubernetes_service" "mimir" {
  metadata {
    name      = "mimir"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      app = "mimir"
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_service" "tempo" {
  metadata {
    name      = "tempo"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector = {
      app = "tempo"
    }
    port {
      port        = 3200
      target_port = 3200
    }
  }
}