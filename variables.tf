variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the PostgreSQL Flexible Server should exist. Changing this forces a new PostgreSQL Flexible Server to be created."
}

variable "location" {
  type        = string
  description = "(Required) The Azure Region where the PostgreSQL Flexible Server should exist. Changing this forces a new PostgreSQL Flexible Server to be created."
   validation {
    condition     = contains(["East US 2", "Central US"], var.location)
    error_message = "The region must be one of: East US 2, CentralUS."
  }
}

# variable "administrator_login" {
#   type        = string
#   description = "(Required) The Administrator login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true."
# }

# variable "administrator_password" {
#   type        = string
#   description = "(Required) The Password associated with the administrator_login for the PostgreSQL Flexible Server. Required when create_mode is Default and authentication.password_auth_enabled is true."
# }

variable "authentication" {
  type        = any
  description = "(Optional) An authentication configuration."
  default     = []
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) The backup retention days for the PostgreSQL Flexible Server."
  default     = null
}

variable "key_vault_key_id" {
  type        = string
  description = "(Required) The ID of the Key Vault Key."
}

variable "primary_user_assigned_identity_id" {
  type        = string
  description = "(Optional) Specifies the primary user managed identity id for a Customer Managed Key. Should be added with identity_ids."
  default     = null
}

variable "geo_backup_key_vault_key_id" {
  type        = string
  description = "(Optional) Specifies the primary user managed identity id for a Customer Managed Key. Should be added with identity_ids."
  default     = null
}

variable "geo_backup_user_assigned_identity_id" {
  type        = string
  description = "(Optional) Specifies the primary user managed identity id for a Customer Managed Key. Should be added with identity_ids."
  default     = null
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Is Geo-Redundant backup enabled on the PostgreSQL Flexible Server. Defaults to false. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = false
}

variable "create_mode" {
  type        = string
  description = "(Optional) The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, Replica and Update. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = "Default"
}

variable "delegated_subnet_id" {
  type        = string
  description = <<EOF
    (Optional) The ID of the virtual network subnet to create the PostgreSQL Flexible Server. 
    The provided subnet should not have any other resource deployed in it and this subnet will be delegated to the PostgreSQL Flexible Server, if not already delegated. 
    Changing this forces a new PostgreSQL Flexible Server to be created.
  EOF
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = <<EOF
    (Optional) The ID of the private DNS zone to create the PostgreSQL Flexible Server. Changing this forces a new PostgreSQL Flexible Server to be created.

    NOTE:
    There will be a breaking change from upstream service at 15th July 2021, the private_dns_zone_id will be required when setting a delegated_subnet_id. 
    For existing flexible servers who don't want to be recreated, you need to provide the private_dns_zone_id to the service team to manually migrate to the specified private DNS zone. 
    The azurerm_private_dns_zone should end with suffix .postgres.database.azure.com
  EOF
  default     = null
}

variable "high_availability" {
  type        = any
  description = "(Optional) High Availability configuration."
  default     = []
}

variable "user_assigned_identity_ids" {
  type        = list(string)
  description = "(Required) A list of User Assigned Managed Identity IDs to be assigned to this PostgreSQL Flexible Server."
}

variable "maintenance_window" {
  type        = any
  description = "(Optional) Maintenance window configuration."
  default     = []
}

variable "point_in_time_restore_time_in_utc" {
  type        = string
  description = "(Optional) The point in time to restore from `source_server_id` when `create_mode` is `PointInTimeRestore`. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = null
}

variable "replication_role" {
  type        = string
  description = <<EOF
    (Optional) The replication role for the PostgreSQL Flexible Server. Possible value is None.

    NOTE:
    The replication_role cannot be set while creating and only can be updated to None for replica server.
  EOF
  default     = null
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU Name for the PostgreSQL Flexible Server. The name of the SKU, follows the `tier` + `name pattern` (e.g. `B_Standard_B1ms`, `GP_Standard_D2s_v3`, `MO_Standard_E4s_v3`)."
  default     = null
}

variable "source_server_id" {
  type        = string
  description = "(Optional) The resource ID of the source PostgreSQL Flexible Server to be restored. Required when `create_mode` is `PointInTimeRestore` or `Replica`. Changing this forces a new PostgreSQL Flexible Server to be created."
  default     = null
}

variable "storage_mb" {
  type        = string
  description = "(Optional) The max storage allowed for the PostgreSQL Flexible Server. Possible values are `32768`, `65536`, `131072`, `262144`, `524288`, `1048576`, `2097152`, `4194304`, `8388608`, and `16777216`."
  default     = null
  validation {
    condition     = contains(["32768", "65536", "131072", "262144", "524288", "1048576", "2097152", "4194304", "8388608", "16777216"], var.storage_mb)
    error_message = "`storage_mb` must be one of the following values: `32768`, `65536`, `131072`, `262144`, `524288`, `1048576`, `2097152`, `4194304`, `8388608`, and `16777216`."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Required) A mapping of tags which should be assigned to the PostgreSQL Flexible Server."
}

variable "pgsql_fs_version" {
  type        = string
  description = <<EOF
    (Optional) The version of PostgreSQL Flexible Server to use. Possible values are `11`, `12`, `13` and `14`. Required when `create_mode` is `Default`. 
    Changing this forces a new PostgreSQL Flexible Server to be created.

    Note:
    When `create_mode` is `Update`, upgrading version wouldn't force a new resource to be created.
  EOF
  default = null
}

variable "zone" {
  type        = string
  description = <<EOF
    (Optional) Specifies the Availability Zone in which the PostgreSQL Flexible Server should be located.

    Note:
    Azure will automatically assign an Availability Zone if one is not specified. 
    If the PostgreSQL Flexible Server fails-over to the Standby Availability Zone, the zone will be updated to reflect the current Primary Availability Zone. 
    You can use Terraform's ignore_changes functionality to ignore changes to the zone and high_availability.0.standby_availability_zone fields should you wish for Terraform to not migrate the PostgreSQL Flexible Server back to it's primary Availability Zone after a fail-over.
  EOF
  default = null
}

variable "timeouts" {
  type        = map(string)
  description = "(Optional) Timeout for Azure PostgreSQL Flexible Server."
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "read", "delete"], t)], false)
    error_message = "Only create, read and delete timeouts can be specified."
  }
}

#~~~~~~~~~~~~~~~~~~~~ ADA Arguments ~~~~~~~~~~~~~~~~~~~~#

variable "object_id" {
    type = string
    description = "(Required) The object ID of a user, service principal or security group in the Azure Active Directory tenant set as the Flexible Server Admin. Changing this forces a new resource to be created."  
}

variable "tenant_id" {
    type = string
    description = "(Required) The Azure Tenant ID. Changing this forces a new resource to be created."  
}

variable "principal_name" {
    type = string
    description = "(Required) The name of Azure Active Directory principal. Changing this forces a new resource to be created."  
}

variable "principal_type" {
    type = string
    description = "(Required) The type of Azure Active Directory principal. Possible values are `Group`, `ServicePrincipal` and `User`. Changing this forces a new resource to be created."  
    validation {
        condition     = contains(["Group", "ServicePrincipal", "User"], var.principal_type)
        error_message = "`principal_type` must be one of the following values: `Group`, `ServicePrincipal` and `User`."
    }
}

#~~~~~~~~~~~~~~~~~~~~ Configuration Arguments ~~~~~~~~~~~~~~~~~~~~#
variable "psql_configurations" {
  description = "List of PostgreSQL Flexible Server configurations to apply"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.psql_configurations :
      config.name != "" && config.value != ""
    ])
    error_message = "All configuration names and values must be non-empty strings."
  }
}

# variable "psql_configuration_name" {
#   type = string
#   description = <<EOF
#     (Required) Specifies the name of the PostgreSQL Configuration, which needs to be a valid PostgreSQL configuration name. 
#     Changing this forces a new resource to be created.

#     NOTE:
#     PostgreSQL provides the ability to extend the functionality using azure extensions, with PostgreSQL azure extensions you should specify the `name` value as `azure.extensions` and the value you wish to allow in the extensions list.
#   EOF
# }

# variable "value" {
#   type = string
#   description = "(Required) Specifies the value of the PostgreSQL Configuration. See the PostgreSQL documentation for valid values."
# }

#~~~~~~~~~~~~~~~~~~~~ Database Arguments ~~~~~~~~~~~~~~~~~~~~#

# variable "psql_database_name" {
#   type = string
#   description = "(Required) The name which should be used for this Azure PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
# }

# variable "charset" {
#   type = string
#   description = "(Optional) Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset. Defaults to `UTF8`. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
#   default = null
# }

# variable "collation" {
#   type = string
#   description = "(Optional) Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation. Defaults to `en_US.utf8`. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
#   default = null
# }

#~~~~~~~~~~~~~~~~~~~~ Firewall Rule Arguments ~~~~~~~~~~~~~~~~~~~~#

# variable "psql_fw_name" {
#   type = string
#   description = "(Required) The name which should be used for this PostgreSQL Flexible Server Firewall Rule. Changing this forces a new PostgreSQL Flexible Server Firewall Rule to be created."
# }

variable "start_ip_address" {
  type = string
  description = "(Required) The Start IP Address associated with this PostgreSQL Flexible Server Firewall Rule."
}

variable "end_ip_address" {
  type = string
  description = "(Required) The End IP Address associated with this PostgreSQL Flexible Server Firewall Rule."
}

variable "length" {
  type        = number
  description = "(Number) The length of the string desired."
  default     = 16
}

variable "keepers" {
  type        = map(string)
  description = "(Map of String) Arbitrary map of values that, when changed, will trigger recreation of resource. See the main provider documentation for more information"
  default     = null
}

variable "lower" {
  type        = bool
  description = "(Boolean) Include lowercase alphabet characters in the result. Default value is true."
  default     = true
}

variable "min_lower" {
  type        = number
  description = "(Number) Minimum number of lowercase alphabet characters in the result. Default value is 0."
  default     = 3
}

variable "min_numeric" {
  type        = number
  description = "(Number) Minimum number of numeric characters in the result. Default value is 0."
  default     = 3
}

variable "min_special" {
  type        = number
  description = "(Number) Minimum number of special characters in the result. Default value is 0."
  default     = 3
}

variable "min_upper" {
  type        = number
  description = "(Number) Minimum number of uppercase alphabet characters in the result. Default value is 0."
  default     = 3
}

variable "numeric" {
  type        = bool
  description = "(Boolean) Include numeric characters in the result. Default value is true."
  default     = true
}

variable "override_special" {
  type        = string
  description = "(String) Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument. The special argument must still be set to true for any overwritten characters to be used in generation."
  default     = "!#$%^_"
}

variable "special" {
  type        = bool
  description = "(Boolean) Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?. Default value is true."
  default     = true
}

variable "upper" {
  type        = bool
  description = "(Boolean) Include uppercase alphabet characters in the result. Default value is true."
  default     = true
}

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Azure PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
}

variable "server_id" {
  type        = string
  description = "(Required) The ID of the Azure PostgreSQL Flexible Server from which to create this PostgreSQL Flexible Server Database. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
}

variable "charset" {
  type        = string
  description = "(Optional) Specifies the Charset for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Charset. Defaults to `UTF8`. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
  default     = null
}

variable "collation" {
  type        = string
  description = "(Optional) Specifies the Collation for the Azure PostgreSQL Flexible Server Database, which needs to be a valid PostgreSQL Collation. Defaults to `en_US.utf8`. Changing this forces a new Azure PostgreSQL Flexible Server Database to be created."
  default     = null
}

variable "timeouts" {
  type        = map(string)
  description = "Timeout for Azure PostgreSQL Flexible Server Database."
  default     = {}
  validation {
    condition     = !contains([for t in keys(var.timeouts) : contains(["create", "read", "delete"], t)], false)
    error_message = "Only create, read and delete timeouts can be specified."
  }
}
