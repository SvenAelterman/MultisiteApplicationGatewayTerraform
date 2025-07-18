module "rt" {
  source  = "Azure/avm-res-network-routetable/azurerm"
  version = "~> 0.4.1"

  name                = local.rt_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.resource.location
  enable_telemetry    = var.enable_telemetry

  routes = {
    DirectToInternet = {
      name           = "DirectToInternet"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  }
}
