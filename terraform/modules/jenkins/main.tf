resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "${var.environment}-jenkins"
    labels = {
      environment = var.environment
      component   = "ci"
    }
  }
}