output "resource_name" {
  description = "The unique name of the User Assigned Managed Identity."
  value       = local.final_resource_name
}

# Debug output

output "instance_formatted" {
  description = "Formatted instance number."
  value       = local.instance_formatted
}
