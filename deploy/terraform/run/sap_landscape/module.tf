/*
  Description:
  Setup common infrastructure
*/

module "sap_landscape" {
<<<<<<< HEAD
  source            = "../../terraform-units/modules/sap_landscape"
  infrastructure    = var.infrastructure
  options           = local.options
  ssh-timeout       = var.ssh-timeout
  sshkey            = var.sshkey
  naming            = module.sap_namegenerator.naming
  service_principal = local.service_principal
  key_vault         = var.key_vault
  deployer_tfstate  = local.use_deployer ? data.terraform_remote_state.deployer[0] : {}
=======
  source                      = "../../terraform-units/modules/sap_landscape"
  infrastructure              = var.infrastructure
  options                     = local.options
  ssh-timeout                 = var.ssh-timeout
  sshkey                      = var.sshkey
  naming                      = module.sap_namegenerator.naming
  service_principal           = local.service_principal
  key_vault                   = var.key_vault
  deployer_tfstate            = data.terraform_remote_state.deployer.outputs
  diagnostics_storage_account = var.diagnostics_storage_account
>>>>>>> 79e40389a0d9173bb3f3e528736162ff22f7b61e
}

module "sap_namegenerator" {
  source             = "../../terraform-units/modules/sap_namegenerator"
  environment        = var.infrastructure.environment
  location           = var.infrastructure.region
  iscsi_server_count = local.iscsi_count
  codename           = lower(try(var.infrastructure.codename, ""))
  random_id          = module.sap_landscape.random_id
  sap_vnet_name      = local.vnet_sap_name_part
}
