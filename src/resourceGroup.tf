module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~> 0.2.1"

  name             = local.rg_name
  location         = var.location
  tags             = local.tags
  enable_telemetry = var.enable_telemetry
}
