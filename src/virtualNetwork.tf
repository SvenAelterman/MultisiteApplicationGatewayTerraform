locals {
  vnet_address_cidr = tonumber(split("/", var.vnet_address_space[0])[1])
}

module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.9.2"

  name                = local.vnet_name
  location            = module.resource_group.resource.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry

  address_space = var.vnet_address_space

  subnets = {
    application_gateway_subnet = {
      name                            = "ApplicationGatewaySubnet"
      default_outbound_access_enabled = false
      address_prefixes                = [cidrsubnet(var.vnet_address_space[0], var.applicationgatewaysubnet_cidr - local.vnet_address_cidr, 0)]
      service_endpoints               = ["Microsoft.KeyVault"]
    }
  }
}
