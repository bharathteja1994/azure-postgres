#####################################################################################################################################
##			                                          Data Sources                                                                     
#####################################################################################################################################
data "azurerm_user_assigned_identity" "identity" {
  name                = local.identity_name
  resource_group_name = local.resource_group_name
}

#####################################################################################################################################
##			                                          Local Place Holder Provisioner Block                                                                     
#####################################################################################################################################
locals {
  /***************************** PGSQL Server Provisioner Values *************************/
  delegated_subnet_id = "<DELEGATED-SUBNET-ID>"
  end_ip_address      = "<END-IP-ADDRESS>"
  identity_name       = "<MANAGED-IDENTITY-NAME>"
  location            = "<LOCATION>"
  object_id           = "<OBJECT-ID>"
  principal_name      = "<PRINCIPAL-NAME/LOGIN-USERNAME>"
  private_dns_zone_id = "<DELEGATED-PRIVATE-DNS-ZONE>"
  psql_config         = jsondecode(file("${path.module}/pgsql_config.json"))
  resource_group_name = "<RESOURCE-GROUP-NAME>"
  sku_name            = "<SERVER-SKU-NAME>"
  start_ip_address    = "<START-IP-ADDRESS>"
  storage_mb          = "<STORAGE-MB>"
  tenant_id           = "be8c08f2-ac07-442c-9a46-ebeeeb5bd4d7"

  /***************************** PITR Provisioner Values *************************/
  # point_in_time_restore_time_in_utc = "<POINT-IN-TIME-RESTORE-IN-UTC>"
}

#####################################################################################################################################
##			                                          Created-by Provisioner                                                        
#####################################################################################################################################


#####################################################################################################################################
##			                                          PGSQL Provisioner                                                        
#####################################################################################################################################
module "pgsql" {
  source  = ""

  authentication = [{
    tenant_id = local.tenant_id
  }]
  backup_retention_days        = 7
  delegated_subnet_id          = local.delegated_subnet_id
  end_ip_address               = local.end_ip_address
  geo_redundant_backup_enabled = false
  high_availability = [{
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }]
  key_vault_key_id = ""
  location         = local.location
  maintenance_window = [{
    day_of_week  = 5
    start_hour   = 9
    start_minute = 10
  }]
  object_id                         = local.object_id
  psql_configurations               = local.psql_config.psql_configurations
  pgsql_fs_version                  = "16"
  primary_user_assigned_identity_id = data.azurerm_user_assigned_identity.identity.id
  principal_name                    = local.principal_name
  principal_type                    = "Group"
  private_dns_zone_id               = local.private_dns_zone_id
  resource_group_name               = local.resource_group_name
  sku_name                          = local.sku_name
  start_ip_address                  = local.start_ip_address
  storage_mb                        = local.storage_mb
  tags                              = var.tags
  tenant_id                         = local.tenant_id
  name      = "${module.pgsql.psql_server_name}-database"
  charset   = "UTF8"
  collation = "en_US.utf8"
  server_id = module.pgsql.psql_server_id
  timeouts = {
    create = "60m"
  }
  user_assigned_identity_ids        = [data.azurerm_user_assigned_identity.identity.id]
  zone                              = "3"
}

#####################################################################################################################################
##			                                          PGSQL PITR Provisioner                                                        
#####################################################################################################################################
# module "pgsql-pitr" {
#   source  = ""

#   authentication = [{
#     tenant_id = local.tenant_id
#   }]
#   backup_retention_days        = 7
#   delegated_subnet_id          = local.delegated_subnet_id
#   end_ip_address               = local.end_ip_address
#   geo_redundant_backup_enabled = false
#   identifier       = "00"
#   key_vault_key_id = module.pgsql-ctmkey.azure_key_id
#   location         = local.location
#   maintenance_window = [{
#     day_of_week  = 5
#     start_hour   = 9
#     start_minute = 10
#   }]
#   object_id      = local.object_id
#   psql_configurations               = local.psql_config.psql_configurations
#   pgsql_fs_version                  = "16"
#   primary_user_assigned_identity_id = data.azurerm_user_assigned_identity.identity.id
#   principal_name = local.principal_name
#   principal_type = "Group"
#   private_dns_zone_id               = local.private_dns_zone_id
#   resource_group_name               = local.resource_group_name
#   serial_number                     = "02"
#   sku_name                          = local.sku_name
#   start_ip_address                  = local.start_ip_address
#   storage_mb                        = local.storage_mb
#   tags                              = module.mandatory_tags.tags
#   tenant_id      = local.tenant_id
#   user_assigned_identity_ids        = [data.azurerm_user_assigned_identity.identity.id]
#   zone                              = "3"

#   /***************************** PITR Provisioner Values *************************/
#    create_mode                       = "PointInTimeRestore"
#    point_in_time_restore_time_in_utc = local.point_in_time_restore_time_in_utc
#    source_server_id                  = module.pgsql.psql_server_id
# }
