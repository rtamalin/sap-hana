// tfvar variables
variable "deployer_rg_name" {
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "codename" {
  type    = string
  default = ""
}

variable "deployer_vnet_address_space" {
    default = ""
}

variable "deployer_subnet_prefix" {
    default = ""
}

variable "vnet_mgmt_name" {
  default = ""
}

variable "vnet_mgmt_arm_id" {
  default = ""
}

variable "sub_mgmt_name" {
  default = ""
}

variable "sub_mgmt_arm_id" {
  default = ""
}

variable "sub_mgmt_nsg_arm_id" {
  default = ""
}

variable "sub_mgmt_nsg_name" {
  default = ""
}

variable "sub_mgmt_nsg_allowed_ips" {
  default = []
}

variable "deployer_size" {
  default = "Standard_D2s_v3"
}

variable "deployer_disk_type" {
  default = "StandardSSD_LRS"
}

variable "deployer_os_source_image_id" {
  default = ""
}

variable "deployer_os" {
  default = {
    "publisher" = "Canonical"
    "offer"     = "UbuntuServer"
    "sku"       = "18.04-LTS"
    "version"   = "latest"
  }
}

variable "deployer_authentication_type" {
  default = "key"
}

variable "deployer_authentication_username" {
  default = "azureadm"
}
variable "deployer_authentication_password" {
  default = ""
}

variable "deployer_sshkey_path_to_public_key" {
  default = ""
}

variable "deployer_sshkey_path_to_private_key" {
  default = ""
}

variable "deployer_private_ip_address" {
  default = []
}

variable "enable_secure_transfer" {
  type = bool
  default = true
}
