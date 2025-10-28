output "namespace" {
  description = "Spinnaker namespace name"
  value       = kubernetes_namespace.spinnaker.metadata[0].name
}