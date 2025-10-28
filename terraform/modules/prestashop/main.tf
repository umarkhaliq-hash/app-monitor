resource "kubernetes_namespace" "prestashop" {
  metadata {
    name = "${var.environment}-${var.app_name}"
    labels = {
      environment = var.environment
      app         = var.app_name
    }
  }
}