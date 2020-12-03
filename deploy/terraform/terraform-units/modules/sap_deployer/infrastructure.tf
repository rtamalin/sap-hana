/*
Description:

  Define infrastructure resources for deployer(s).
*/

// Create managed resource group for sap deployer with CanNotDelete lock


/*
*---------------------------------------+---------------------------------------*
*                                                                               *
*                                RESOURCE GROUPS                                *
*                                                                               *
*---------------------------------------4---------------------------------------8
Function:
  Creates a Resorce Group.

Description:
  Resorce Group in which to group all the Resources that are deployed for the
  Deployer in this unit of execution.

Usage:
  Variable                   : local.enable_deployers [true|false]
    - Derived from           : local.deployer_input as [true|false] based on legnth greater than zero
      Variable               : local.deployer_input
      - Derived from         : var.deployers as object copy
        Variable             : var.deployers
        - Derived from       : Defined empty, passed in from module call
          Variable           : var.deployers
          - Derived from     : var.deployers in module caller
            Variable         : var.deployers
            - Derived from   : Passed in if present
              Variable       : var.deployers
              - Derived from : Defined as empty List Map


  Variable            : local.enable_deployers [true|false] derived from local.deployer_input based on legnth greater than zero
    Variable          : local.deployer_input is a copy of var.defaults
      Variable        : var.defaults defined empty
        Module Caller : Pass var.deployers object into module
          Input       : Any overrides are inserted (JSON or TFVARS)
            Main      : Defines empty var.deployers object [{}]


  Variable            : local.rg_name derived from default format("%s%s", local.prefix, local.resource_suffixes.deployer_rg) or overridden with var.infrastructure.resource_group.name
    Variable          : var.infrastructure defined empty
      Module Caller   : Pass var.infrastructure object into module
          Input       : Any overrides are inserted (JSON or TFVARS)
            Main      : Defines empty var.infrastructure object {}
    Variable            : local.prefix derived from 
      Variable          : local.deployer_input is a copy of var.defaults
        Variable        : var.defaults defined empty
          Module Caller : Pass var.deployers object into module
            Input       : Any overrides are inserted (JSON or TFVARS)
              Main      : Defines empty var.deployers object [{}]
    Variable            : local.resource_suffixes.deployer_rg derived from 
      Variable          : local.deployer_input is a copy of var.defaults
        Variable        : var.defaults defined empty
          Module Caller : Pass var.deployers object into module
            Input       : Any overrides are inserted (JSON or TFVARS)
              Main      : Defines empty var.deployers object [{}]


local.region


*/

resource "azurerm_resource_group" "deployer" {
  count    = local.enable_deployers ? 1 : 0
  name     = local.rg_name
  location = local.region
}

// TODO: Add management lock when this issue is addressed https://github.com/terraform-providers/terraform-provider-azurerm/issues/5473

// Create/Import management vnet
resource "azurerm_virtual_network" "vnet_mgmt" {
  count               = (local.enable_deployers && ! local.vnet_mgmt_exists) ? 1 : 0
  name                = local.vnet_mgmt_name
  location            = azurerm_resource_group.deployer[0].location
  resource_group_name = azurerm_resource_group.deployer[0].name
  address_space       = [local.vnet_mgmt_addr]
}

data "azurerm_virtual_network" "vnet_mgmt" {
  count               = (local.enable_deployers && local.vnet_mgmt_exists) ? 1 : 0
  name                = split("/", local.vnet_mgmt_arm_id)[8]
  resource_group_name = split("/", local.vnet_mgmt_arm_id)[4]
}

// Create/Import management subnet
resource "azurerm_subnet" "subnet_mgmt" {
  count                = (local.enable_deployers && ! local.sub_mgmt_exists) ? 1 : 0
  name                 = local.sub_mgmt_name
  resource_group_name  = local.vnet_mgmt_exists ? data.azurerm_virtual_network.vnet_mgmt[0].resource_group_name : azurerm_virtual_network.vnet_mgmt[0].resource_group_name
  virtual_network_name = local.vnet_mgmt_exists ? data.azurerm_virtual_network.vnet_mgmt[0].name : azurerm_virtual_network.vnet_mgmt[0].name
  address_prefixes     = [local.sub_mgmt_prefix]
}

data "azurerm_subnet" "subnet_mgmt" {
  count                = (local.enable_deployers && local.sub_mgmt_exists) ? 1 : 0
  name                 = split("/", local.sub_mgmt_arm_id)[10]
  resource_group_name  = split("/", local.sub_mgmt_arm_id)[4]
  virtual_network_name = split("/", local.sub_mgmt_arm_id)[8]
}

// Creates boot diagnostics storage account for Deployer
resource "azurerm_storage_account" "deployer" {
  count                     = local.enable_deployers ? 1 : 0
  name                      = local.storageaccount_names
  resource_group_name       = azurerm_resource_group.deployer[0].name
  location                  = azurerm_resource_group.deployer[0].location
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  enable_https_traffic_only = local.enable_secure_transfer
}
