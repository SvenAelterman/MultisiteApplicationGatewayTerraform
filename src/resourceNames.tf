module "uami_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "uami"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "rg_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "rg"

  always_use_short_region_name = var.always_use_short_region_name
  resource_type_override       = "rg-networking"
  instance_formatted_length    = var.instance_formatted_length
}

module "pip_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "pip"

  always_use_short_region_name = var.always_use_short_region_name
  resource_type_override       = "pip-agw"
  instance_formatted_length    = var.instance_formatted_length
}

module "kv_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "kv"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "vnet_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "vnet"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "agw_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "agw"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "nsg_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "nsg"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}

module "rt_name" {
  source = "./modules/naming"

  workload_name = var.workload_name
  environment   = var.environment
  instance      = var.instance
  region        = var.location
  resource_type = "rt"

  always_use_short_region_name = var.always_use_short_region_name
  instance_formatted_length    = var.instance_formatted_length
}
