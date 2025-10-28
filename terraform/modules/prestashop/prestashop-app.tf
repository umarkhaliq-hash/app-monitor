# PrestaShop app will be deployed ONLY via Jenkins CI + Spinnaker CD
# Terraform only manages the namespace for the app

resource "kubernetes_service" "prestashop" {
  metadata {
    name      = "prestashop"
    namespace = kubernetes_namespace.prestashop.metadata[0].name
  }
  spec {
    selector = {
      app = "prestashop"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.prestashop.metadata[0].name
  }
  spec {
    selector = {
      app = "mysql"
    }
    port {
      port        = 3306
      target_port = 3306
    }
  }
}