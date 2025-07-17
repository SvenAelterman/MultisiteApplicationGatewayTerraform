module "public_ip_address" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "~> 0.2.0"

  name                = local.pip_name
  location            = module.resource_group.resource.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry

  domain_name_label = local.pip_domain_name_label
}
