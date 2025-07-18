locals {
  vnet_address_cidr = tonumber(split("/", var.vnet_address_space[0])[1])

  virtual_network_connection_name           = "vwan-connection-${var.workload_name}-${var.location}"
  application_gateway_subnet_address_prefix = cidrsubnet(var.vnet_address_space[0], var.applicationgatewaysubnet_cidr - local.vnet_address_cidr, 0)
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
  dns_servers = {
    dns_servers = var.custom_dns_servers
  }

  diagnostic_settings = local.diagnostic_settings

  subnets = {
    application_gateway_subnet = {
      name                            = "ApplicationGatewaySubnet"
      default_outbound_access_enabled = false
      address_prefixes                = [local.application_gateway_subnet_address_prefix]
      service_endpoints               = ["Microsoft.KeyVault"]

      network_security_group = { id = module.nsg.resource_id }
      route_table            = { id = module.rt.resource_id }
    }
  }
}

module "vwan_hub_connection" {
  count = var.virtual_hub_id != "" ? 1 : 0

  source  = "Azure/avm-ptn-virtualwan/azurerm//modules/vnet-conn"
  version = "~> 0.12.4"

  virtual_network_connections = {
    connection = {
      name                      = local.virtual_network_connection_name
      remote_virtual_network_id = module.virtual_network.resource_id
      virtual_hub_id            = var.virtual_hub_id
      // Do not propagate 0/0 to this connection, the App GW must have direct Internet egress
      internet_security_enabled = false
    }
  }
}
