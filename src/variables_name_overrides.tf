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

variable "agw_name" {
  description = "The name of the Application Gateway. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}

variable "nsg_name" {
  description = "The name of the Network Security Group. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}

variable "rt_name" {
  description = "The name of the Route Table. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}

variable "agw_waf_name" {
  description = "The name of the Application Gateway WAF. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}

variable "rg_name" {
  description = "The name of the Resource Group. This overrides the automatically generated name based on the naming convention."
  type        = string
  default     = ""
}
