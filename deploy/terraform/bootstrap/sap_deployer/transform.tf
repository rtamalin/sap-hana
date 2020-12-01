// Input variables from json
locals {
json_environment = try(var.infrastructure.environment, "")
json_deployer_rg_name = try(var.infrastructure.resource_group.name, "")
json_location = try(var.infrastructure.region, "")
json_deployer_vnet_address_space = try(var.infrastructure.vnets.management.address_space, "")
json_deployer_subnet_prefix = try(var.infrastructure.vnets.management.subnet_mgmt.prefix, "")
json_vnet_mgmt_name=try(var.infrastructure.vnets.management.name, "")
json_vnet_mgmt_arm_id=try(var.infrastructure.vnets.management.arm_id, "")
json_sub_mgmt_name=try(var.infrastructure.vnets.management.subnet_mgmt.name, "")
json_sub_mgmt_arm_id=try(var.infrastructure.vnets.management.subnet_mgmt.arm_id, "")
json_sub_mgmt_nsg_arm_id=try(var.infrastructure.vnets.management.nsg_mgmt.arm_id, "")
json_sub_mgmt_nsg_name=try(var.infrastructure.vnets.management.nsg_mgmt.name, "")
json_sub_mgmt_nsg_allowed_ips=try(var.infrastructure.vnets.management.subnet_mgmt.nsg.allowed_ips, [])
json_deployer_authentication_type=try(var.deployers[0].authentication.type, "")
json_deployer_authentication_username=try(var.deployers[0].authentication.username, "")
json_deployer_authentication_password=try(var.deployers[0].authentication.password, "")
json_deployer_sshkey_path_to_public_key=try(var.sshkey.path_to_public_key, "")
json_deployer_sshkey_path_to_private_key=try(var.sshkey.path_to_private_key, "")
json_deployer_private_ip_address=try(var.deployers[0].private_ip_address, "")
json_enable_secure_transfer=try(var.options.enable_secure_transfer, "")
json_key_vault=try(var.key_vault, {})
json_ssh-timeout=try(var.ssh-timeout, "")
}

locals {
    infrastructure = {
        region = local.json_location != "" ? local.json_location : var.location
        environment = local.json_environment != "" ? local.json_environment : var.environment
        resource_group = {
            name = local.json_deployer_rg_name != "" ? local.json_deployer_rg_name : var.deployer_rg_name
        }
        vnets = {
            management = {
                name = local.json_vnet_mgmt_name != "" ? local.json_vnet_mgmt_name : var.vnet_mgmt_name
                address_space = local.json_deployer_vnet_address_space != "" ? local.json_deployer_vnet_address_space : var.deployer_vnet_address_space
                arm_id = local.json_vnet_mgmt_arm_id != "" ? local.json_vnet_mgmt_arm_id : var.vnet_mgmt_arm_id
                subnet_mgmt = {
                    name = local.json_sub_mgmt_name != "" ? local.json_sub_mgmt_name : var.sub_mgmt_name
                    prefix = local.json_deployer_subnet_prefix != "" ? local.json_deployer_subnet_prefix : var.deployer_subnet_prefix
                    arm_id = local.json_sub_mgmt_arm_id != "" ? local.json_sub_mgmt_arm_id : var.sub_mgmt_arm_id
                    nsg = {
                        name = local.json_sub_mgmt_nsg_name != "" ? local.json_sub_mgmt_nsg_name : var.sub_mgmt_nsg_name
                        allowed_ips = local.json_sub_mgmt_nsg_allowed_ips != [] ? local.json_sub_mgmt_nsg_allowed_ips : var.sub_mgmt_nsg_allowed_ips
                    }
                }
            }
        }
    }
    deployers = [
        {
            authentication = {
                type = local.json_deployer_authentication_type != "" ? local.json_deployer_authentication_type : var.deployer_authentication_type
                username = local.json_deployer_authentication_username != "" ? local.json_deployer_authentication_username : var.deployer_authentication_username
                password = local.json_deployer_authentication_password != "" ? local.json_deployer_authentication_password : var.deployer_authentication_password
            }
        }
    ]
    sshkey = {
        path_to_public_key = local.json_deployer_sshkey_path_to_public_key != "" ? local.json_deployer_sshkey_path_to_public_key : var.deployer_sshkey_path_to_public_key
        path_to_private_key = local.json_deployer_sshkey_path_to_private_key != "" ? local.json_deployer_sshkey_path_to_private_key : var.deployer_sshkey_path_to_private_key
 
    }
    ssh-timeout = local.json_ssh-timeout
    key_vault = local.json_key_vault
    options = {
        enable_secure_transfer = local.json_enable_secure_transfer != "" ? local.json_enable_secure_transfer : var.enable_secure_transfer
    }   
}
