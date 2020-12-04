variable "api-version" {
  description = "IMDS API Version"
  default     = "2019-04-30"
}

variable "auto-deploy-version" {
  description = "Version for automated deployment"
  default     = "Fe"
}

variable "scenario" {
  description = "Deployment Scenario"
  default     = "sap_system"
}

variable "max_timeout" {
  description = "Maximum time allowed to spend for curl"
  default     = 10
}

// Registers the current deployment state with Azure's Metadata Service (IMDS)
resource "azurerm_virtual_machine_extension" "dbserver_linux" {
  count                = local.enable_deployment && upper(local.anydb_ostype) == "LINUX" ? local.db_server_count : 0
  name                 = "IMDS"
  virtual_machine_id   = azurerm_linux_virtual_machine.dbserver[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl --silent --output /dev/null --max-time ${var.max_timeout} -i -H \"Metadata: \"true\"\" -H \"user-agent: SAP AutoDeploy/${var.auto-deploy-version}; scenario=anydb_linux; deploy-status=Terraform_${var.scenario}\" http://169.254.169.254/metadata/instance?api-version=${var.api-version}"
    }
SETTINGS

}

resource "azurerm_virtual_machine_extension" "dbserver_windows" {
  count                = local.enable_deployment && upper(local.anydb_ostype) == "WINDOWS" ? local.db_server_count : 0
  name                 = "IMDS"
  virtual_machine_id   = azurerm_windows_virtual_machine.dbserver[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "Invoke-RestMethod -Headers @{\"Metadata\"=\"true\"; \"user-agent\"=\"SAP AutoDeploy/${var.auto-deploy-version}\"; \"scenario\"=\"anydb_windows\"; \"deploy-status\"=\"Terraform_${var.scenario}\"} -Method GET -Uri http://169.254.169.254/metadata/instance?api-version=${var.api-version}"
    }
SETTINGS

}

resource "azurerm_virtual_machine_extension" "observer_linux" {
  count                = local.deploy_observer && upper(local.anydb_ostype) == "LINUX" ? length(local.zones) : 0
  name                 = "IMDS"
  virtual_machine_id   = azurerm_linux_virtual_machine.dbserver[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl --silent --output /dev/null --max-time ${var.max_timeout} -i -H \"Metadata: \"true\"\" -H \"user-agent: SAP AutoDeploy/${var.auto-deploy-version}; scenario=observer_linux; deploy-status=Terraform_${var.scenario}\" http://169.254.169.254/metadata/instance?api-version=${var.api-version}"
    }
SETTINGS

}

resource "azurerm_virtual_machine_extension" "observer_windows" {
  count                = local.deploy_observer && upper(local.anydb_ostype) == "WINDOWS" ? length(local.zones) : 0
  name                 = "IMDS"
  virtual_machine_id   = azurerm_windows_virtual_machine.dbserver[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "Invoke-RestMethod -Headers @{\"Metadata\"=\"true\"; \"user-agent\"=\"SAP AutoDeploy/${var.auto-deploy-version}\"; \"scenario\"=\"observer_windows\"; \"deploy-status\"=\"Terraform_${var.scenario}\"} -Method GET -Uri http://169.254.169.254/metadata/instance?api-version=${var.api-version}"
    }
SETTINGS

}
