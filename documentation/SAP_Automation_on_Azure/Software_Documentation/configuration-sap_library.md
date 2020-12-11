<!-- TODO: 
Remove files and maintain here in documentation
deploy/terraform/bootstrap/sap_library/saplibrary_full.json
deploy/terraform/bootstrap/sap_library/saplibrary.json
deploy/terraform/run/sap_library/saplibrary_full.json
deploy/terraform/run/sap_library/saplibrary.json
-->
### <img src="../assets/images/UnicornSAPBlack256x256.png" width="64px"> SAP Deployment Automation Framework <!-- omit in toc -->
<br/><br/>

# Configuration - SAP Library <!-- omit in toc -->

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
  "tfstate_resource_id"               : "",                                       <-- On reinitialization for Remote Statefile usage.
  "infrastructure": {
    "environment"                     : "NP",                                     <-- Required Parameter
    "region"                          : "eastus2"                                 <-- Required Parameter
  },
  "deployer": {
    "environment"                     : "NP",                                     <-- Required Parameter
    "region"                          : "eastus2",                                <-- Required Parameter
    "vnet"                            : "DEP00"                                   <-- Required Parameter
  },
  "key_vault":{
    "kv_user_id"                      : "",                                       <-- Optional
    "kv_prvt_id"                      : ""                                        <-- Optional
  }
}                                                                                 <-- JSON Closing tag
```

| Object Path                                   | Parameter                     | Type          | Default  | Description |
| :-------------------------------------------- | :---------------------------- | ------------- | :------- | :---------- |
|                                              | `tfstate_resource_id`         | Remote State  |          | - This parameter is introduce when transitioning from a LOCAL deployment to a REMOTE Statefile deployment, during Reinitialization.<br/>- This is the Azure Resource ID for the Storage Account in which the Statefiles are stored. Typically this is deployed by the SAP Library execution unit. |
| infrastructure.                               | `environment`                 | **required**  | -------- | The Environment is a 5 Character designator used for partitioning. An example of partitioning would be, PROD / NP (Production and Non-Production). Environments may also be tied to a unique SPN or Subscription. |
| <p>                                           | `region`                      | **required**  | -------- | This specifies the Azure Region in which to deploy. |
| deployer.                                     | `environment`                 | **required**  | -------- | This represents the environment of the deployer. Typically this will be the same as the `infrastructure.environment`. When multi-subscription is supported, this can be set to a different value. |
| <p>                                           | `region`                      | **required**  | -------- | Azure Region in which the Deployer was deployed. |
| <p>                                           | `vnets`                       | **required**  | -------- | Designator used for the Deployer VNET. |
| key_vault.                                    | `kv_user_id`                  | optional      |          | <!-- TODO: Yunzi --> |
| <p>                                           | `kv_prvt_id`                  | optional      |          | <!-- TODO: Yunzi --> |

<br/><br/><br/><br/>

---

<br/><br/>

# Examples
<br/>

## Minimal (Default) input parameter JSON

```
{
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2"
  },
  "deployer": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "vnet"                            : "DEP00"
  }
}
```

<br/><br/><br/>

## Complete input parameter JSON

```
{
  "tfstate_resource_id"               : "",
  "infrastructure": {
    "environment"                     : "NP",
    "region"                          : "eastus2"
  },
  "deployer": {
    "environment"                     : "NP",
    "region"                          : "eastus2",
    "vnet"                            : "DEP00"
  },
  "key_vault":{
    "kv_user_id"                      : "",
    "kv_prvt_id"                      : ""
  }
}
```




