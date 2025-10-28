resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "${var.environment}-monitoring"
    labels = {
      environment = var.environment
      component   = "monitoring"
    }
  }
}