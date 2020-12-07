<!-- TODO: 
Remove files and maintain here in documentation
deploy/terraform/bootstrap/sap_deployer/deployer_full.json
deploy/terraform/bootstrap/sap_deployer/deployer.json
-->
### <img src="../../../../../assets/images/UnicornSAPBlack256x256.png" width="64px"> SAP Deployment Automation Framework <!-- omit in toc -->
<br/><br/>

# Configuration - Deployer <!-- omit in toc -->

<br/>

## Table of Contents
<br/>

- [Parameter file construction](#parameter-file-construction)
  - [Example minimal parameter file, using defaults](#example-minimal-parameter-file-using-defaults)
  - [Example complete parameter file](#example-complete-parameter-file)


<br/><br/><br/><br/>

---
<br/>

# Parameter file construction

JSON structure

```
{                                                                                 <-- JSON opening tag
  "infrastructure": {
    "environment"                     : "NP",                                     <-- Required Parameter
    "region"                          : "eastus2",                                <-- Required Parameter
    "vnets": {
      "management": {
        "name"                        : "NP-EUS2-DEP00-vnet",                     <-- Override Name
        "address_space"               : "10.0.0.0/26",                            <-- Required Parameter
        "subnet_mgmt": {
          "prefix"                    : "10.0.0.16/28"                            <-- Required Parameter
        }
      }
    }
  },
  "options": {
    "enable_secure_transfer"          : true,                                     <-- Optional, Default: true
    "enable_deployer_public_ip"       : false                                     <-- Optional, Default: false
  },
  "key_vault": {
    "kv_user_id"                      : "",                                       <-- Optional
    "kv_prvt_id"                      : "",                                       <-- Optional
    "kv_sshkey_prvt"                  : "",                                       <-- Optional
    "kv_sshkey_pub"                   : "",                                       <-- Optional
    "kv_username"                     : "",                                       <-- Optional
    "kv_pwd"                          : ""                                        <-- Optional
  }
}                                                                                 <-- JSON Closing tag
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| infrastructure.`environment`                          | **required**  | |
| infrastructure.`region`                               | **required**  | |
| infrastructure.vnets.management.`name`                | override      | |
| infrastructure.vnets.management.`address_space`       | **required**  | |
| infrastructure.vnets.management.subnet_mgmt.`prefix`  | **required**  | |
| options.`enable_secure_transfer`                      | optional      | |
| options.`enable_deployer_public_ip`                   | optional      | |
| key_vault.`kv_user_id`                                | Optional      | |
| key_vault.`kv_prvt_id`                                | Optional      | |
| key_vault.`kv_sshkey_prvt`                            | Optional      | |
| key_vault.`kv_sshkey_pub`                             | Optional      | |
| key_vault.`kv_username`                               | Optional      | |
| key_vault.`kv_pwd`                                    | Optional      | |


<br/><br/><br/><br/>

---


## Example minimal parameter file, using defaults 

```
{
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "vnets": {
      "management": {
        "address_space"               : "10.0.0.0/26",
        "subnet_mgmt": {
          "prefix"                    : "10.0.0.16/28"
        }
      }
    }
  }
}
```


## Example complete parameter file

```
{
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "vnets": {
      "management": {
        "name"                        : "NP-EUS2-DEP00-vnet",
        "address_space"               : "10.0.0.0/26",
        "subnet_mgmt": {
          "prefix"                    : "10.0.0.16/28"
        }
      }
    }
  },
  "options": {
    "enable_secure_transfer"          : true,
    "enable_deployer_public_ip"       : false
  },
  "key_vault": {
    "kv_user_id"                      : "",
    "kv_prvt_id"                      : "",
    "kv_sshkey_prvt"                  : "",
    "kv_sshkey_pub"                   : "",
    "kv_username"                     : "",
    "kv_pwd"                          : ""
  }
}

```




