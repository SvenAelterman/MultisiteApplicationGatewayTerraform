resource "azurerm_key_vault_certificate" "tls_certificate" {
  count = length(var.certificate_pfx_path) > 0 ? 1 : 0

  name         = var.kv_certificate_name
  key_vault_id = module.keyvault.resource_id

  certificate {
    contents = filebase64(var.certificate_pfx_path)
    password = var.certificate_pfx_password
  }
}
