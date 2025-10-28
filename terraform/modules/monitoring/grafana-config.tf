resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  data = {
    "datasources.yaml" = <<EOF
apiVersion: 1
datasources:
- name: Loki
  type: loki
  access: proxy
  url: http://loki.dev-monitoring.svc.cluster.local:3100
- name: Prometheus
  type: prometheus
  access: proxy
  url: http://prometheus.dev-monitoring.svc.cluster.local:9090
- name: Tempo
  type: tempo
  access: proxy
  url: http://tempo.dev-monitoring.svc.cluster.local:3200
EOF
  }
}