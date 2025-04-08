# Creation of Azure PostgreSQL Flexible Server
locals {
  server-name       = "${local.name}"
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "${local.server-name}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  dynamic "authentication" {
    for_each = var.authentication
    content {
      active_directory_auth_enabled = true
      password_auth_enabled         = false
      tenant_id                     = lookup(authentication.value, "tenant_id", null)
    }
  }
  backup_retention_days = try(var.backup_retention_days, null)
  customer_managed_key {
      key_vault_key_id                  = var.key_vault_key_id
      primary_user_assigned_identity_id = var.primary_user_assigned_identity_id
      geo_backup_key_vault_key_id       = var.geo_backup_key_vault_key_id
      geo_backup_user_assigned_identity_id = var.geo_backup_user_assigned_identity_id
  }
  geo_redundant_backup_enabled = try(var.geo_redundant_backup_enabled, false)
  create_mode                  = try(var.create_mode, "Default")
  delegated_subnet_id          = var.delegated_subnet_id
  private_dns_zone_id          = var.private_dns_zone_id
  public_network_access_enabled = false
  dynamic "high_availability" {
    for_each = var.high_availability
    content {
      mode                      = lookup(high_availability.value, "mode", null)
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", null)
    }
  }
  identity {
    type         = "UserAssigned"
    identity_ids = var.user_assigned_identity_ids
  }
  dynamic "maintenance_window" {
    for_each = var.maintenance_window
    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", null)
      start_hour   = lookup(maintenance_window.value, "start_hour", null)
      start_minute = lookup(maintenance_window.value, "start_minute", null)
    }
  }
  point_in_time_restore_time_in_utc = try(var.point_in_time_restore_time_in_utc, null)
  replication_role                  = try(var.replication_role, null)
  sku_name                          = try(var.sku_name, null)
  source_server_id                  = try(var.source_server_id, null)
  storage_mb                        = try(var.storage_mb, null)
  tags                              = merge(var.tags, local.tags_db, {"database-platform-name" = local.server-name})
  version                           = try(var.pgsql_fs_version, null)
  zone                              = var.zone

  timeouts {
    create = lookup(var.timeouts, "create", "1h")
    read   = lookup(var.timeouts, "read", "30m")
    delete = lookup(var.timeouts, "delete", "1h")
  }
  lifecycle { ignore_changes = [authentication] }
}

# Creation of Azure PostgreSQL Flexible Server Active Directory Administrator

resource "azurerm_postgresql_flexible_server_active_directory_administrator" "main" {
  count = var.create_mode != "Default" ? 0 : 1
  server_name         = azurerm_postgresql_flexible_server.main.name
  resource_group_name = var.resource_group_name
  object_id = var.object_id
  tenant_id = var.tenant_id
  principal_name = var.principal_name
  principal_type = var.principal_type

  timeouts {
    create = lookup(var.timeouts, "create", "30m")
    read   = lookup(var.timeouts, "read", "30m")
    delete = lookup(var.timeouts, "delete", "30m")
  }
  
  depends_on = [ azurerm_postgresql_flexible_server.main ]
}

# Creation of Azure PostgreSQL Flexible Server Configuration

resource "azurerm_postgresql_flexible_server_configuration" "main" {
  count     = length(var.psql_configurations)
  name      = var.psql_configurations[count.index].name
  server_id = azurerm_postgresql_flexible_server.main.id
  value = var.psql_configurations[count.index].value

  timeouts {
    create = lookup(var.timeouts, "create", "30m")
    read   = lookup(var.timeouts, "read", "30m")
    delete = lookup(var.timeouts, "delete", "30m")
  }

  depends_on = [ azurerm_postgresql_flexible_server.main ]

}

# Creation of Azure PostgreSQL Flexible Server Firewall Rule

resource "azurerm_postgresql_flexible_server_firewall_rule" "main" {
  name             = "${local.server-name}-fwrule-name"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address

  timeouts {
    create = lookup(var.timeouts, "create", "30m")
    read   = lookup(var.timeouts, "read", "20m")
    delete = lookup(var.timeouts, "delete", "30m")
  }

  depends_on = [ azurerm_postgresql_flexible_server.main ]
  
}

# Creation of Azure PostgreSQL Flexible Server Database

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.name
  server_id = var.server_id
  charset   = var.charset
  collation = var.collation

  timeouts {
    create = lookup(var.timeouts, "create", "30m")
    read   = lookup(var.timeouts, "read", "20m")
    delete = lookup(var.timeouts, "delete", "30m")
  }
}

