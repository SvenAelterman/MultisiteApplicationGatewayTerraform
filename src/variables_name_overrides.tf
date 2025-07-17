variable "kv_name" {
  description = "The name of the Key Vault. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "The name of the Virtual Network. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}
