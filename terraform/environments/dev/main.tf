module "infrastructure" {
  source = "../../"
  
  environment = "dev"
  app_name    = "prestashop"
}