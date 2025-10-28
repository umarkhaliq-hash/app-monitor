resource "kubernetes_config_map" "promtail" {
  metadata {
    name      = "promtail-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  data = {
    "config.yml" = <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://loki:3100/loki/api/v1/push
scrape_configs:
- job_name: kubernetes-pods
  kubernetes_sd_configs:
  - role: pod
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_name]
    target_label: pod
  - source_labels: [__meta_kubernetes_namespace]
    target_label: namespace
  - source_labels: [__meta_kubernetes_pod_container_name]
    target_label: container
EOF
  }
}

resource "kubernetes_daemonset" "promtail" {
  metadata {
    name      = "promtail"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  spec {
    selector {
      match_labels = {
        app = "promtail"
      }
    }
    template {
      metadata {
        labels = {
          app = "promtail"
        }
      }
      spec {
        container {
          name  = "promtail"
          image = "grafana/promtail:latest"
          args  = ["-config.file=/etc/promtail/config.yml"]
          volume_mount {
            name       = "config"
            mount_path = "/etc/promtail"
          }
          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
            read_only  = true
          }
          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }
        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.promtail.metadata[0].name
          }
        }
        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }
        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }
      }
    }
  }
}