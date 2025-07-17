locals {
  subscription_id = var.subscription_id

  tags = var.tags

  instance_formatted = format("%0${var.instance_formatted_length}d", var.instance)

  pip_domain_name_label = length(var.pip_domain_name_label) > 0 ? var.pip_domain_name_label : "${var.workload_name}-${var.environment}-${local.instance_formatted}"
}

# Resource names
locals {
  uami_name = module.uami_name.resource_name
  pip_name  = module.pip_name.resource_name
  rg_name   = module.rg_name.resource_name
  kv_name   = length(var.kv_name) == 0 ? module.kv_name.resource_name : var.kv_name
  vnet_name = length(var.vnet_name) == 0 ? module.vnet_name.resource_name : var.vnet_name
}
