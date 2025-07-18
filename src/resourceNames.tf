module "uami_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "UAMI"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "rg_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "RG"
  naming_convention = "CRHE-{workload_name}-{environment}-{resource_type}-{region}-{instance}"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "pip_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "PIP"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  resource_type_override       = "PIP-AGW"
  instance_formatted_length    = var.instance_formatted_length
}

module "kv_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "KV"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "vnet_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "VNET"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "agw_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "AGW"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "nsg_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "NSG"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "rt_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "RT"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "agw_waf_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "WFRules"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "agw_component_name_structure" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "AGW"
  naming_convention = var.naming_convention

  resource_type_override       = "{resource_type}"
  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "diag_name" {
  source = "./modules/naming"

  workload_name     = var.workload_name
  environment       = var.environment
  instance          = var.instance
  region            = var.location
  resource_type     = "Diag"
  naming_convention = var.naming_convention

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}
