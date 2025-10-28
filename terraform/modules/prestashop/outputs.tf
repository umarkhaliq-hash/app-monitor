output "namespace" {
  description = "PrestaShop namespace name"
  value       = kubernetes_namespace.prestashop.metadata[0].name
}