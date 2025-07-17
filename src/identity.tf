module "uami" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "~> 0.3.4"

  name                = local.uami_name
  location            = module.resource_group.resource.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry
}

