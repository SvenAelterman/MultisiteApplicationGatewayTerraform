variable "subscription_id" {
  description = "The Azure subscription ID where the resources will be deployed."
  type        = string
}

variable "naming_convention" {
  description = "Naming convention for the resources."
  type        = string
  default     = "{workload_name}-{environment}-{resource_type}-{region}-{instance}"
}

variable "workload_name" {
  description = "The name of the workload. Will be used for resource names if `{workload_name}` is present in the naming convention."
  type        = string
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

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Tags to apply to the resources."
  type        = map(string)
  default     = {}
}

variable "enable_telemetry" {
  description = "Enable telemetry for the Azure Verified Modules."
  type        = bool
  default     = true
}

variable "always_use_short_region_name" {
  description = "Whether to always use the short region name in the resource name, even if using the full region name doesn't exceed the resource type's maximum length."
  type        = bool
  default     = false
}

variable "pip_domain_name_label" {
  description = "Domain name label prefix for the public IP address."
  type        = string
  default     = ""
}

variable "instance_formatted_length" {
  description = "Length of the formatted instance number."
  type        = number
  default     = 2
}

variable "kv_certificate_name" {
  description = "Name of the Key Vault certificate."
  type        = string
  default     = "appgw-certificate"
}

variable "certificate_pfx_path" {
  description = "Path to the certificate file (PFX) to be imported into Key Vault."
  type        = string
  default     = ""
}

variable "certificate_pfx_password" {
  description = "Password for the PFX certificate file."
  type        = string
  default     = ""
  sensitive   = true
  // TODO: validate ends in .pfx
}

variable "vnet_address_space" {
  description = "Address space for the new Virtual Network."
  type        = list(string)

  validation {
    condition     = length(var.vnet_address_space) > 0 && alltrue([for cidr in var.vnet_address_space : can(cidrhost(cidr, 0))])
    error_message = "vnet_address_space must be a non-empty list of valid CIDR blocks."
  }
}

variable "applicationgatewaysubnet_cidr" {
  description = "CIDR for the Application Gateway subnet."
  type        = number
  default     = 26
}

variable "application_gateway_sku" {
  description = "SKU for the Application Gateway."
  type        = string
  default     = "WAF_v2"
}

variable "agw_configuration" {
  description = "Configuration settings for the Application Gateway."
  type = object({
    listeners = map(object({
      protocol           = string
      frontend_host_name = string
      backend_host_name  = optional(string)
      backend_pool       = string
      backend_port       = optional(number)
    }))
    create_http_to_https_redirects = optional(bool, true)
    backend_pools = map(object({
      fqdns                        = optional(list(string), [])
      ip_addresses                 = optional(list(string), [])
      backend_cert_public_key_file = optional(string, "")
      name                         = string
    }))
  })
  default = {
    listeners = {
      first_site = {
        protocol           = "Https"
        frontend_host_name = "example.com"
        backend_host_name  = "internal.example.com"

        // Reference to the backend pool key defined below
        backend_pool = "first_pool"
      }
    }

    create_http_to_https_redirects = true

    backend_pools = {
      first_pool = {
        name  = "sample"
        fqdns = ["internal.example.com"]
        // -- OR --
        ip_addresses = ["10.0.1.4"]
      }
    }
  }
}

variable "dns_subscription_id" {
  description = "The subscription ID for the public DNS zone."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the public DNS zone."
  type        = string
}

variable "dns_resource_group_name" {
  description = "The name of the resource group where the DNS zone is located."
  type        = string
}

variable "virtual_hub_id" {
  description = "The ID of the vWAN Virtual Hub to connect the new Virtual Network to."
  type        = string
}

variable "agw_waf_mode" {
  description = "The mode of the Application Gateway Web Application Firewall (WAF)."
  type        = string
  default     = "Prevention"
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for Application Gateway diagnostics."
  type        = string
}

variable "custom_dns_servers" {
  description = "List of custom DNS servers to be used by the Virtual Network."
  type        = list(string)
  default     = []
}
