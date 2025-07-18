locals {
  port_name_https                       = "port-443"
  port_name_http                        = "port-80"
  cert_name                             = "cert-${var.workload_name}"
  frontend_ip_configuration_public_name = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "PIP")
}

locals {
  // Create the object structure for the backend_address_pools variable for the module
  backend_address_pools = { for name, pool in var.agw_configuration.backend_pools :
    name => {
      name         = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "BEP-${pool.name}")
      ip_addresses = pool.ip_addresses != null ? pool.ip_addresses : []
      fqdns        = pool.fqdns != null ? pool.fqdns : []
    }
  }

  // Create the object structure for the backend_http_settings variable for the module
  backend_http_settings = { for name, listener in var.agw_configuration.listeners :
    name => {
      name                  = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "BES-${name}")
      cookie_based_affinity = "Disabled"
      port                  = coalesce(listener.backend_port, 443)
      protocol              = "Https"
      path                  = "/"
      request_timeout       = 20

      pick_host_name_from_backend_http_settings = listener.backend_host_name != null && length(listener.backend_host_name) > 0
      host_name                                 = listener.backend_host_name

      // TODO: probe_name                                = local.probe_name

      connection_draining = {
        enable_connection_draining = true
        drain_timeout_sec          = 30
      }

      trusted_root_certificate_names = var.agw_configuration.backend_pools[listener.backend_pool].backend_cert_public_key_file != "" ? [local.trusted_root_certificate[base64encode(var.agw_configuration.backend_pools[listener.backend_pool].backend_cert_public_key_file)].name] : null
    }
  }

  // Create the object structure for the backend_http_settings variable for the module
  https_listeners = { for name, listener in var.agw_configuration.listeners :
    "${name}-${listener.protocol}" => {
      name : replace(module.agw_component_name_structure.resource_name, "{resource_type}", "LSN-${name}-${listener.protocol}")
      protocol                       = listener.protocol
      host_name                      = listener.frontend_host_name
      frontend_port_name             = listener.protocol == "Https" ? local.port_name_https : local.port_name_http
      frontend_ip_configuration_name = local.frontend_ip_configuration_public_name
      ssl_certificate_name           = local.cert_name
    }
  }

  http_listeners = { for name, listener in var.agw_configuration.listeners :
    "${name}-http" => {
      name                           = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "LSN-${name}-http")
      protocol                       = "Http"
      host_name                      = listener.frontend_host_name
      frontend_port_name             = local.port_name_http
      frontend_ip_configuration_name = local.frontend_ip_configuration_public_name
    } if listener.protocol == "Https" && var.agw_configuration.create_http_to_https_redirects
  }

  all_listeners = merge(local.https_listeners, local.http_listeners)
  // We need to be able to pull an ordinal position for each listener to create unique priorities later
  listener_array = [for name, l in var.agw_configuration.listeners : name]

  request_routing_rules = { for name, listener in var.agw_configuration.listeners :
    "${name}-${listener.protocol}-routing" => {
      name                       = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "Rules-${name}-${listener.protocol}")
      http_listener_name         = local.all_listeners["${name}-${listener.protocol}"].name
      backend_address_pool_name  = local.backend_address_pools[listener.backend_pool].name
      backend_http_settings_name = local.backend_http_settings[name].name
      priority                   = 100 + index(local.listener_array, name)
      rule_type                  = "Basic"
    }
  }

  request_redirect_rules = { for name, listener in var.agw_configuration.listeners :
    "${name}-http-redirect" => {
      name                        = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "Rules-${name}-http")
      http_listener_name          = local.http_listeners["${name}-http"].name
      redirect_configuration_name = local.redirect_configuration[name].name
      priority                    = 50 + index(local.listener_array, name)
      # Not applicable for a redirect rule but required by the module
      rule_type                  = "Basic"
      backend_http_settings_name = ""
      backend_address_pool_name  = ""
    } if listener.protocol == "Https" && var.agw_configuration.create_http_to_https_redirects
  }

  all_routing_rules = merge(local.request_routing_rules, local.request_redirect_rules)

  redirect_configuration = { for name, listener in var.agw_configuration.listeners :
    name => {
      name                 = replace(module.agw_component_name_structure.resource_name, "{resource_type}", "Redirect-${name}")
      redirect_type        = "Permanent"
      include_path         = true
      include_query_string = true
      target_listener_name = local.https_listeners["${name}-${listener.protocol}"].name
    } if listener.protocol == "Https" && var.agw_configuration.create_http_to_https_redirects
  }

  unique_public_key_file = distinct([for pool in var.agw_configuration.backend_pools :
    {
      file = pool.backend_cert_public_key_file
    } if pool.backend_cert_public_key_file != ""
  ])

  trusted_root_certificate = { for i, cert in local.unique_public_key_file :
    base64encode(cert.file) => {
      name = "root-cert-${i}"
      data = file(cert.file) // Assumes the contents are already base64 encoded PEM
    }
  }
}

/*******************************************************************************
APPLICATION GATEWAY WAF POLICY
*******************************************************************************/

module "application_gateway_waf_policy" {
  source  = "Azure/avm-res-network-applicationgatewaywebapplicationfirewallpolicy/azurerm"
  version = "~> 0.1.0"

  name                = local.agw_waf_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.resource.location
  tags                = var.tags
  enable_telemetry    = var.enable_telemetry

  policy_settings = {
    enabled                                   = true
    file_upload_limit_enforcement             = true
    file_upload_limit_in_mb                   = 100
    mode                                      = var.agw_waf_mode
    js_challenge_cookie_expiration_in_minutes = 30
  }

  managed_rules = {
    managed_rule_set = {
      rule_set_1 = {
        type    = "OWASP" # This is default but here for clarity
        version = "3.2"
        enabled = false
      }
    }
  }
}

/*******************************************************************************
APPLICATION GATEWAY
*******************************************************************************/

module "application_gateway" {
  source  = "Azure/avm-res-network-applicationgateway/azurerm"
  version = "~> 0.4.2"

  name                = local.agw_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.resource.location
  tags                = local.tags
  enable_telemetry    = var.enable_telemetry

  public_ip_resource_id = module.public_ip_address.resource_id
  create_public_ip      = false

  gateway_ip_configuration = {
    subnet_id = module.virtual_network.subnets.application_gateway_subnet.resource_id
  }

  frontend_ip_configuration_public_name = local.frontend_ip_configuration_public_name

  app_gateway_waf_policy_resource_id = var.application_gateway_sku == "WAF_v2" ? module.application_gateway_waf_policy.resource_id : null

  diagnostic_settings = local.diagnostic_settings

  # WAF : Azure Application Gateways v2 are always deployed in a highly available fashion with multiple instances by default. Enabling autoscale ensures the service is not reliant on manual intervention for scaling.
  sku = {
    name     = var.application_gateway_sku
    tier     = var.application_gateway_sku
    capacity = 0 # Set the initial capacity to 0 for autoscaling
  }

  autoscale_configuration = {
    min_capacity = 1
    max_capacity = 2
  }

  # frontend port configuration block for the application gateway
  # WAF : Secure all incoming connections using HTTPS for production services with end-to-end SSL/TLS or SSL/TLS termination at the Application Gateway to protect against attacks and ensure data remains private and encrypted between the web server and browsers.
  frontend_ports = {
    port-443 = {
      name = local.port_name_https
      port = 443
    }
    port-80 = {
      name = local.port_name_http
      port = 80
    }
  }

  backend_address_pools = local.backend_address_pools

  trusted_root_certificate = local.trusted_root_certificate

  # Backend http settings configuration for the application gateway
  backend_http_settings = local.backend_http_settings

  # Http Listeners configuration for the application gateway
  http_listeners = local.all_listeners

  # Routing rules configuration for the backend pool
  request_routing_rules = local.all_routing_rules

  # SSL Certificate Block
  ssl_certificates = {
    cert = var.certificate_pfx_path != "" ? {
      name                = local.cert_name
      key_vault_secret_id = azurerm_key_vault_certificate.tls_certificate[0].versionless_secret_id
    } : null
  }

  # HTTP to HTTPS redirect configurations
  redirect_configuration = local.redirect_configuration

  #   probe_configurations = {
  #     probe = {
  #       name     = local.probe_name
  #       protocol = "Https"
  #       port     = 443
  #       # http://-/adfs/probe is supposed to be used but the customer for whom this was developed does not have this endpoint available.
  #       # https://learn.microsoft.com/windows-server/identity/ad-fs/overview/ad-fs-requirements#load-balancer-requirements
  #       # This URL is publicly accessible and should return a 200 OK response.
  #       path                                      = var.health_probe_path
  #       interval                                  = 30
  #       timeout                                   = 30
  #       unhealthy_threshold                       = 3
  #       pick_host_name_from_backend_http_settings = true

  #       match = {
  #         status_code = ["200"]
  #       }
  #     }
  #   }

  zones = ["1", "2", "3"]

  managed_identities = {
    user_assigned_resource_ids = [
      module.uami.resource_id
    ]
  }
}
