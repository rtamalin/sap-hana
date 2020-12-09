<!-- TODO: 
Remove files and maintain here in documentation
deploy/terraform/run/sap_system/sapsystem_full.json
deploy/terraform/run/sap_system/sapsystem.json
-->
### <img src="../../../../../assets/images/UnicornSAPBlack256x256.png" width="64px"> SAP Deployment Automation Framework <!-- omit in toc -->
<br/><br/>

# Configuration - SAP Workload VNET <!-- omit in toc -->

<br/>

## Table of Contents
<br/>

- [Parameter file construction](#parameter-file-construction)
- [Examples](#examples)
  - [Minimal (Default) input parameter JSON](#minimal-default-input-parameter-json)
  - [Complete input parameter JSON](#complete-input-parameter-json)


<br/><br/><br/><br/>

---
<br/>

# Parameter file construction

JSON structure

```
{                                                                                 <-- JSON opening tag
  "tfstate_resource_id"               : "",                                       <-- Required Parameter
  "deployer_tfstate_key"              : "",                                       <-- Required Parameter
  "landscape_tfstate_key"             : "",                                       <-- Required Parameter
  "infrastructure": {                                                             <-- Required Block
    "environment"                     : "NP",                                     <-- Required Parameter
    "region"                          : "eastus2",                                <-- Required Parameter
    "resource_group": {                                                           <-- Optional Block
      "is_existing"                   : "false",                                  <-- Optional
      "arm_id"                        : ""                                        <-- Optional
    },
    "anchor_vms": {                                                               <-- Optional Block
      "sku"                           : "Standard_D4s_v4",                        <-- Optional
      "authentication": {
        "type"                        : "key",
        "username"                    : "azureadm"
      },
      "accelerated_networking"        : true,
      "os": {
        "publisher"                   : "SUSE",
        "offer"                       : "sles-sap-12-sp5",
        "sku"                         : "gen1"
      },
      "nic_ips"                       : ["", "", ""],
      "use_DHCP"                      : false
    },
    "vnets": {
      "sap": {
        "is_existing"                 : "false",
        "arm_id"                      : "",
        "name"                        : "",
        "address_space"               : "10.1.0.0/16",                            <-- Depracate; Do not use
        "subnet_db": {
          "prefix"                    : "10.1.1.0/28"                             <-- Required Parameter
        },
        "subnet_web": {
          "prefix"                    : "10.1.1.16/28"                            <-- Required Parameter
        },
        "subnet_app": {
          "prefix"                    : "10.1.1.32/27"                            <-- Required Parameter
        },
        "subnet_admin": {
          "prefix"                    : "10.1.1.64/27"                            <-- Required Parameter
        }
      }
    }
  },
  "databases": [
    {
      "platform"                      : "HANA",                                   <-- Required Parameter
      "high_availability"             : false,                                    <-- Required Parameter
      "db_version"                    : "2.00.050",
      "size"                          : "Demo",                                   <-- Required Parameter
      "os": {
        "publisher"                   : "SUSE",                                   <-- Required Parameter
        "offer"                       : "sles-sap-12-sp5",                        <-- Required Parameter
        "sku"                         : "gen1"                                    <-- Required Parameter
      },
      "zones"                         : ["1"],
      "credentials": {
        "db_systemdb_password"        : "<db_systemdb_password>",
        "os_sidadm_password"          : "<os_sidadm_password>",
        "os_sapadm_password"          : "<os_sapadm_password>",
        "xsa_admin_password"          : "<xsa_admin_password>",
        "cockpit_admin_password"      : "<cockpit_admin_password>",
        "ha_cluster_password"         : "<ha_cluster_password>"
      },
      "avset_arm_ids"                 : [
                                          "/subscriptions/xxxx/resourceGroups/yyyy/providers/Microsoft.Compute/availabilitySets/PROTO-SID_db_avset"
                                        ],
      "use_DHCP"                      : false,
      "dbnodes": [
        {
          "name"                      : "hdb1",
          "role"                      : "worker"
        },
        {
          "name"                      : "hdb2",
          "role"                      : "worker"
        },
        {
          "name"                      : "hdb3",
          "role"                      : "standby"
        }
      ]
    }
  ],
  "application": {
    "enable_deployment"               : true,
    "sid"                             : "PRD",
    "scs_instance_number"             : "00",
    "ers_instance_number"             : "10",
    "scs_high_availability"           : false,
    "application_server_count"        : 3,
    "webdispatcher_count"             : 1,
    "app_zones"                       : ["1", "2"],
    "scs_zones"                       : ["1"],
    "web_zones"                       : ["1"],
    "use_DHCP"                        : false,
    "authentication": {
      "type"                          : "key",
      "username"                      : "azureadm"
    }
  },
  "sshkey": {
    "path_to_public_key"              : "sshkey.pub",
    "path_to_private_key"             : "sshkey"
  },
  "options": {
    "enable_secure_transfer"          : true,
    "enable_prometheus"               : true
  }
}                                                                                 <-- JSON Closing tag
```


| Parameter                                             | Type          | Default  | Description |
| :---------------------------------------------------- | ------------- | :------- | :---------- |
| `tfstate_resource_id`                                 | **required**  | -------- | This is the Azure Resource ID for the Storage Account in which the Statefiles are stored. Typically this is deployed by the SAP Library execution unit. |
| `deployer_tfstate_key`                                | **required**  | -------- | <!-- TODO: --> |
| `landscape_tfstate_key`                               | **required**  | -------- | <!-- TODO: --> |
| infrastructure.`environment`                          | **required**  | -------- | The Environment is a 5 Character designator used for partitioning. An example of partitioning would be, PROD / NP (Production and Non-Production). Environments may also be tied to a unique SPN or Subscription. |
| infrastructure.`region`                               | **required**  | -------- | This specifies the Azure Region in which to deploy. |
| infrastructure.resource_group.`is_existing`           | depracate     |          | to be deprecated <!-- TODO: --> |
| infrastructure.resource_group.`arm_id`                | optional      |  | <!-- TODO: --> |
| infrastructure.anchor_vms.`sku`                       |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.authentication.`type`       |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.authentication.`username`   |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.`accelerated_networking`    |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.os.`publisher`              |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.os.`offer`                  |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.os.`sku`                    |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.`nic_ips`                   |  |  | <!-- TODO: Kimmo --> |
| infrastructure.anchor_vms.`use_DHCP`                  |  |  | <!-- TODO: Kimmo --> |
| infrastructure.vnets.sap.`is_existing`                |  |  | <!-- TODO: --> |
| infrastructure.vnets.sap.`arm_id`                     |  |  | <!-- TODO: --> |
| infrastructure.vnets.sap.`name`                       |  |  | <!-- TODO: --> |
| infrastructure.vnets.sap.`address_space`              |  |  | <!-- TODO: --> |
| infrastructure.vnets.sap.subnet_db.`prefix`           | **required**  | <!-- TODO: --> |
| infrastructure.vnets.sap.subnet_web.`prefix`          | optional      | <!-- TODO: --> |
| infrastructure.vnets.sap.subnet_app.`prefix`          | **required**  | <!-- TODO: --> |
| infrastructure.vnets.sap.subnet_admin.`prefix`        | **required**  | <!-- TODO: --> |
| databases.[].`platform`                               | **required**  | <!-- TODO: --> |
| databases.[].`high_availability`                      |  |  | <!-- TODO: --> |
| databases.[].`db_version`                             | depracate     | <!-- TODO: --> |
| databases.[].`size`                                   | **required**  | <!-- TODO: --> |
| databases.[].os.`publisher`                           |  |  | <!-- TODO: --> |
| databases.[].os.`offer`                               |  |  | <!-- TODO: --> |
| databases.[].os.`sku`                                 |  |  | <!-- TODO: --> |
| databases.[].`zones`                                  |  |  | <!-- TODO: --> |
| databases.[].credentials.`db_systemdb_password`       | depracate     | <!-- TODO: --> |
| databases.[].credentials.`os_sidadm_password`         | depracate     | <!-- TODO: --> |
| databases.[].credentials.`os_sapadm_password`         | depracate     | <!-- TODO: --> |
| databases.[].credentials.`xsa_admin_password`         | depracate     | <!-- TODO: --> |
| databases.[].credentials.`cockpit_admin_password`     | depracate     | <!-- TODO: --> |
| databases.[].credentials.`ha_cluster_password`        | depracate     | <!-- TODO: --> |
| databases.[].`avset_arm_ids.[]`                       |  |  | <!-- TODO: --> |
| databases.[].`use_DHCP`                               |  |  | <!-- TODO: --> |
| databases.[].dbnodes.[].`name`                        |  |  | <!-- TODO: --> |
| databases.[].dbnodes.[].`role`                        |  |  | <!-- TODO: --> |
| application.`enable_deployment`                       |  |  | <!-- TODO: --> |
| application.`sid`                                     | **required**  | <!-- TODO: --> |
| application.`scs_instance_number`                     |  |  | <!-- TODO: --> |
| application.`ers_instance_number`                     |  |  | <!-- TODO: --> |
| application.`scs_high_availability`                   |  |  | <!-- TODO: --> |
| application.`application_server_count`                |  |  | <!-- TODO: --> |
| application.`webdispatcher_count`                     |  |  | <!-- TODO: --> |
| application.`app_zones`                               |  |  | <!-- TODO: --> |
| application.`scs_zones`                               |  |  | <!-- TODO: --> |
| application.`web_zones`                               |  |  | <!-- TODO: --> |
| application.`use_DHCP`                                |  |  | <!-- TODO: --> |
| application.authentication.`type`                     |  |  | <!-- TODO: --> |
| application.authentication.`username`                 | optional      | azureadm | <!-- TODO: --> |
| sshkey.`path_to_public_key`                           | optional      |  | <!-- TODO: --> |
| sshkey.`path_to_private_key`                          | optional      |  | <!-- TODO: --> |
| options.`enable_secure_transfer`                      | depracate     | true     | <!-- TODO: --> |
| options.`enable_prometheus`                           | depracate     |          | Depracate <!-- TODO: --> |





<br/><br/><br/><br/>

---

<br/>

# Examples
<br/><br/>

## Minimal (Default) input parameter JSON

```
{
  "tfstate_resource_id"               : "",
  "deployer_tfstate_key"              : "",
  "landscape_tfstate_key"             : "",
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "vnets": {
      "sap": {
        "subnet_db": {
          "prefix"                    : "10.1.1.0/28"
        },
        "subnet_web": {
          "prefix"                    : "10.1.1.16/28"
        },
        "subnet_app": {
          "prefix"                    : "10.1.1.32/27"
        },
        "subnet_admin": {
          "prefix"                    : "10.1.1.64/27"
        }
      }
    }
  },
  "databases": [
    {
      "platform"                      : "HANA",
      "high_availability"             : false,
      "db_version"                    : "2.00.050",
      "size"                          : "Demo",
      "os": {
        "publisher"                   : "SUSE",
        "offer"                       : "sles-sap-12-sp5",
        "sku"                         : "gen1"
      }
    }
  ],
  "application": {
    "enable_deployment"               : true,
    "sid"                             : "PRD",
    "scs_instance_number"             : "00",
    "ers_instance_number"             : "10",
    "scs_high_availability"           : false,
    "application_server_count"        : 3,
    "webdispatcher_count"             : 1,
    "app_zones": [],
    "scs_zones": [],
    "web_zones": [],
    "authentication": {
      "type"                          : "key",
      "username"                      : "azureadm"
    }
  },
  "options": {
    "enable_secure_transfer"          : true,
    "ansible_execution"               : false,
    "enable_prometheus"               : true
  }
}
```

<br/><br/><br/>

## Complete input parameter JSON

```
{
  "tfstate_resource_id"               : "",
  "deployer_tfstate_key"              : "",
  "landscape_tfstate_key"             : "",
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "resource_group": {
      "is_existing"                   : "false",
      "arm_id"                        : ""
    },
    "anchor_vms": {
      "sku"                           : "Standard_D4s_v4",
      "authentication": {
        "type"                        : "key",
        "username"                    : "azureadm"
      },
      "accelerated_networking"        : true,
      "os": {
        "publisher"                   : "SUSE",
        "offer"                       : "sles-sap-12-sp5",
        "sku"                         : "gen1"
      },
      "nic_ips"                       : ["", "", ""],
      "use_DHCP"                      : false
    },
    "vnets": {
      "sap": {
        "is_existing"                 : "false",
        "arm_id"                      : "",
        "name"                        : "",
        "address_space"               : "10.1.0.0/16",
        "subnet_db": {
          "prefix"                    : "10.1.1.0/28"
        },
        "subnet_web": {
          "prefix"                    : "10.1.1.16/28"
        },
        "subnet_app": {
          "prefix"                    : "10.1.1.32/27"
        },
        "subnet_admin": {
          "prefix"                    : "10.1.1.64/27"
        }
      }
    }
  },
  "databases": [
    {
      "platform"                      : "HANA",
      "high_availability"             : false,
      "db_version"                    : "2.00.050",
      "size"                          : "Demo",
      "os": {
        "publisher"                   : "SUSE",
        "offer"                       : "sles-sap-12-sp5",
        "sku"                         : "gen1"
      },
      "zones"                         : ["1"],
      "credentials": {
        "db_systemdb_password"        : "<db_systemdb_password>",
        "os_sidadm_password"          : "<os_sidadm_password>",
        "os_sapadm_password"          : "<os_sapadm_password>",
        "xsa_admin_password"          : "<xsa_admin_password>",
        "cockpit_admin_password"      : "<cockpit_admin_password>",
        "ha_cluster_password"         : "<ha_cluster_password>"
      },
      "avset_arm_ids"                 : [
                                          "/subscriptions/xxxx/resourceGroups/yyyy/providers/Microsoft.Compute/availabilitySets/PROTO-SID_db_avset"
                                        ],
      "use_DHCP"                      : false,
      "dbnodes": [
        {
          "name"                      : "hdb1",
          "role"                      : "worker"
        },
        {
          "name"                      : "hdb2",
          "role"                      : "worker"
        },
        {
          "name"                      : "hdb3",
          "role"                      : "standby"
        }
      ]
    }
  ],
  "application": {
    "enable_deployment"               : true,
    "sid"                             : "PRD",
    "scs_instance_number"             : "00",
    "ers_instance_number"             : "10",
    "scs_high_availability"           : false,
    "application_server_count"        : 3,
    "webdispatcher_count"             : 1,
    "app_zones"                       : ["1", "2"],
    "scs_zones"                       : ["1"],
    "web_zones"                       : ["1"],
    "use_DHCP"                        : false,
    "authentication": {
      "type"                          : "key",
      "username"                      : "azureadm"
    }
  },
  "sshkey": {
    "path_to_public_key"              : "sshkey.pub",
    "path_to_private_key"             : "sshkey"
  },
  "options": {
    "enable_secure_transfer"          : true,
    "enable_prometheus"               : true
  }
}
```




