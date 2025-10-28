# PrestaShop app will be deployed via Jenkins CI/CD pipeline
# Only namespace is managed by Terraform

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