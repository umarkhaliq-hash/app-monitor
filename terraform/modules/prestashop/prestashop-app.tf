resource "kubernetes_deployment" "prestashop" {
  metadata {
    name      = "prestashop"
    namespace = kubernetes_namespace.prestashop.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "prestashop"
      }
    }
    template {
      metadata {
        labels = {
          app = "prestashop"
        }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "80"
          "prometheus.io/path"   = "/metrics"
        }
      }
      spec {
        container {
          name  = "prestashop"
          image = "prestashop/prestashop:8.1-apache"
          port {
            container_port = 80
          }
          env {
            name  = "DB_SERVER"
            value = "mysql"
          }
          env {
            name  = "DB_NAME"
            value = "prestashop"
          }
          env {
            name  = "DB_USER"
            value = "prestashop"
          }
          env {
            name  = "DB_PASSWD"
            value = "prestashop"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.prestashop.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"
          port {
            container_port = 3306
          }
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }
          env {
            name  = "MYSQL_DATABASE"
            value = "prestashop"
          }
          env {
            name  = "MYSQL_USER"
            value = "prestashop"
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = "prestashop"
          }
        }
      }
    }
  }
}

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