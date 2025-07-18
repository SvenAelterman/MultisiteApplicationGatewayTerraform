# Procedurally create a valid Azure resource name

locals {
  region        = var.always_use_short_region_name ? local.short_regions[var.region] : var.region
  resource_type = length(var.resource_type_override) > 0 ? var.resource_type_override : var.resource_type

  sub_workload_name_processed  = length(var.sub_workload_name) > 0 ? replace(var.naming_convention, "{sub_workload_name}", var.sub_workload_name) : replace(var.naming_convention, "${var.segment_separator}{sub_workload_name}", "")
  segment_separators_processed = local.remove_segment_separators ? replace(local.sub_workload_name_processed, var.segment_separator, "") : local.sub_workload_name_processed

  initial_resource_name = replace(replace(replace(replace(
    replace(
      replace(
        local.segment_separators_processed,
        "{resource_type}", local.resource_type
      ),
      "{instance}", local.instance_formatted
    ),
    "{workload_name}", var.workload_name
    ),
    "{environment}", var.environment
    ),
    "{region}", local.region
  ), "{sub_workload_name}", var.sub_workload_name)

  // Create an initial attempt at creating a shorter resource name
  initial_short_resource_name = replace(replace(replace(replace(
    replace(
      replace(
        local.segment_separators_processed,
        "{resource_type}", local.resource_type
      ),
      "{instance}", var.instance
    ),
    "{workload_name}", var.workload_name
    ),
    "{environment}", var.environment
    ),
    "{region}", local.short_regions[var.region]
  ), "{sub_workload_name}", var.sub_workload_name)

  // TODO: Calculate how many characters (if any) still need to be removed from the short resource name
  // TODO: Implement lowercase requirement

  final_resource_name = substr(length(local.initial_resource_name) > local.resource_type_restrictions[var.resource_type].max_length ? local.initial_short_resource_name : local.initial_resource_name, 0, local.resource_type_restrictions[var.resource_type].max_length)
}
