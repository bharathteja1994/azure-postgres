output "psql_server_id" {
  value = azurerm_postgresql_flexible_server.main.id
  description = "The ID of the PostgreSQL Flexible Server."
}

output "psql_server_name" {
  value = azurerm_postgresql_flexible_server.main.name
  description = "The name which should be used for this PostgreSQL Flexible Server."
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
  description = "The FQDN of the PostgreSQL Flexible Server."
}

output "public_network_access_enabled" {
  value = azurerm_postgresql_flexible_server.main.public_network_access_enabled
  description = "Is public network access enabled?"
}

######################################################

output "psql_ada_id" {
  value = azurerm_postgresql_flexible_server_active_directory_administrator.main[*].id
  description = "The ID of the PostgreSQL Flexible Server Active Directory Administrator."
}

######################################################

output "psql_configuration_id" {
    value = azurerm_postgresql_flexible_server_configuration.main[*].id
    description = "The ID of the PostgreSQL Configuration."
}

######################################################

output "psql_fw_id" {
  value = azurerm_postgresql_flexible_server_firewall_rule.main.id
  description = "The ID of the PostgreSQL Flexible Server Firewall Rule."
}

output "id" {
  value       = azurerm_postgresql_flexible_server_database.main.id
  description = "The ID of the Azure PostgreSQL Flexible Server Database."
}
