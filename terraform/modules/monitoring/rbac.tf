resource "kubernetes_service_account" "monitoring" {
  metadata {
    name      = "monitoring-sa"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "monitoring" {
  metadata {
    name = "monitoring-role"
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "nodes", "namespaces", "limitranges", "persistentvolumes", "persistentvolumeclaims", "configmaps", "secrets", "events", "resourcequotas", "replicationcontrollers"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "replicasets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "monitoring" {
  metadata {
    name = "monitoring-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.monitoring.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.monitoring.metadata[0].name
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
}