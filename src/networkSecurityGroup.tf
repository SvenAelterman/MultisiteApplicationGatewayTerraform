locals {
  nsg_security_rules = {
    AllowInternetInbound = {
      name                         = "AllowInternetInbound"
      access                       = "Allow"
      destination_address_prefixes = [module.public_ip_address.public_ip_address, local.application_gateway_subnet_address_prefix]
      destination_port_ranges      = ["80", "443"]
      direction                    = "Inbound"
      priority                     = 200
      protocol                     = "Tcp"
      source_address_prefix        = "*"
      source_port_range            = "*"
    }
    AllowGatewayManagerInbound = {
      name                       = "AllowGatewayManagerInbound"
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "65200-65535"
      direction                  = "Inbound"
      priority                   = 300
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
    }
    AllowLoadBalancerInbound = {
      name                       = "AllowLoadBalancerInbound"
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      direction                  = "Inbound"
      priority                   = 400
      protocol                   = "*"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
    }
  }
}

module "nsg" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "~> 0.4.0"

  name                = local.nsg_name
  resource_group_name = module.resource_group.name
  tags                = local.tags
  location            = module.resource_group.resource.location
  enable_telemetry    = var.enable_telemetry

  security_rules = local.nsg_security_rules
}
