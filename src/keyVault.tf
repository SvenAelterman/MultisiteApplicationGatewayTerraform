module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.10.0"

  name                = local.kv_name
  location            = module.resource_group.resource.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  diagnostic_settings = local.diagnostic_settings

  role_assignments = {
    uami_kvsu = {
      principal_id               = module.uami.principal_id
      role_definition_id_or_name = "Key Vault Secrets User"
      principal_type             = "ServicePrincipal"
    }
    caller_kva = {
      principal_id               = data.azurerm_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Administrator"
      principal_type             = "User"
    }
  }

  wait_for_rbac_before_secret_operations = {
    create = "30s"
  }

  network_acls = {
    bypass         = "AzureServices" // Required for App Gateway to retrieve the certificate
    default_action = "Deny"

    ip_rules = [
      data.http.runner_ip.response_body
    ]

    virtual_network_subnet_ids = [
      // The Application Gateway must be able to access the Key Vault to retrieve the certificate
      module.virtual_network.subnets.application_gateway_subnet.resource_id
    ]
  }
}
