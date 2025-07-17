variable "naming_convention" {
  description = "Naming convention for the resources."
  type        = string
  default     = "{workload_name}-{sub_workload_name}-{environment}-{resource_type}-{region}-{instance}"
}

variable "workload_name" {
  description = "The name of the workload. Will be used for resource names if `{workload_name}` is present in the naming convention."
  type        = string
  default     = "adfs"
}

variable "environment" {
  description = "The environment for the deployment. Will be used for resource names if `{environment}` is present in the naming convention."
  type        = string
  default     = "test"
}

variable "instance" {
  description = "Instance number for the deployment. Will be used for resource names if `{instance}` is present in the naming convention."
  type        = number
  default     = 1
}

variable "region" {
  description = "The Azure region where the resources will be deployed."
  type        = string
  default     = "eastus2"
}

variable "resource_type" {
  description = "The type of resource being created. Will be used in the naming convention."
  type        = string
  // TODO: Define allowed types
}

variable "instance_formatted_length" {
  description = "The formatted length of the instance number. Leading zeroes will be added."
  type        = number
  default     = 2
}

variable "sub_workload_name" {
  description = "The name of the sub-workload. Will be used for resource names if `{sub_workload_name}` is present in the naming convention."
  type        = string
  default     = ""
}

variable "segment_separator" {
  description = "The separator used between segments in the naming convention."
  type        = string
  default     = "-"
  // TODO: Allowed: - _ . or empty
}

variable "use_vowel_removal_strategy" {
  description = "Whether to use the vowel removal strategy for creating short names."
  type        = bool
  default     = false
}

variable "random_chars_to_add" {
  description = "Number of random characters to add to the end of the resource name for uniqueness."
  type        = number
  default     = 0
}

variable "remove_segment_separators" {
  description = "Whether to remove segment separators from the resource name, regardless of the allowed segment separators for the resource type."
  type        = bool
  default     = false
}

variable "always_use_short_region_name" {
  description = "Whether to always use the short region name in the resource name, even if using the full region name doesn't exist the resource type's maximum length."
  type        = bool
  default     = false
}

variable "resource_type_override" {
  description = "Override the resource type used in the naming convention. Useful for resource types of which multiple are created, like public IPs, resource groups, etc."
  type        = string
  default     = ""
}

