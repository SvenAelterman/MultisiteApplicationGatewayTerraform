locals {
  subscription_id = var.subscription_id

  tags = var.tags

  instance_formatted = format("%0${var.instance_formatted_length}d", var.instance)

  pip_domain_name_label = length(var.pip_domain_name_label) > 0 ? lower(var.pip_domain_name_label) : lower("${var.workload_name}-${var.environment}-${local.instance_formatted}")

  diagnostic_settings = {
    setting = {
      name                  = module.diag_name.resource_name
      metric_categories     = []
      workspace_resource_id = var.log_analytics_workspace_id
    }
  }
}

# Resource names
locals {
  uami_name    = module.uami_name.resource_name
  pip_name     = module.pip_name.resource_name
  rg_name      = module.rg_name.resource_name
  kv_name      = length(var.kv_name) == 0 ? module.kv_name.resource_name : var.kv_name
  vnet_name    = length(var.vnet_name) == 0 ? module.vnet_name.resource_name : var.vnet_name
  agw_name     = length(var.agw_name) == 0 ? module.agw_name.resource_name : var.agw_name
  nsg_name     = length(var.nsg_name) == 0 ? module.nsg_name.resource_name : var.nsg_name
  rt_name      = length(var.rt_name) == 0 ? module.rt_name.resource_name : var.rt_name
  agw_waf_name = length(var.agw_waf_name) == 0 ? module.agw_waf_name.resource_name : var.agw_waf_name
}
