resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "${var.environment}-spinnaker"
    labels = {
      environment = var.environment
      component   = "cd"
    }
  }
}