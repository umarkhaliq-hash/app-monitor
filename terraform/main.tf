module "prestashop" {
  source = "./modules/prestashop"
  
  environment = var.environment
  app_name    = var.app_name
}

module "jenkins" {
  source = "./modules/jenkins"
  
  environment = var.environment
}

module "spinnaker" {
  source = "./modules/spinnaker"
  
  environment = var.environment
}

module "monitoring" {
  source = "./modules/monitoring"
  
  environment = var.environment
}