output "namespaces" {
  description = "Created namespaces"
  value = {
    prestashop = module.prestashop.namespace
    jenkins    = module.jenkins.namespace
    spinnaker  = module.spinnaker.namespace
    monitoring = module.monitoring.namespace
  }
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}