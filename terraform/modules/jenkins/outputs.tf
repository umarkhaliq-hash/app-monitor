output "namespace" {
  description = "Jenkins namespace name"
  value       = kubernetes_namespace.jenkins.metadata[0].name
}