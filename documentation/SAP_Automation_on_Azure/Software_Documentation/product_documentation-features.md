### <img src="../assets/images/UnicornSAPBlack256x256.png" width="64px"> SAP Deployment Automation Framework <!-- omit in toc -->
<br/><br/>

# Product Documentation - Features <!-- omit in toc -->

<br/>

## Table of Contents <!-- omit in toc -->
<br/>

- [Infrastructure as Code](#infrastructure-as-code)
- [Managed Resources](#managed-resources)
- [Configuration as Code](#configuration-as-code)
- [Orchestration](#orchestration)


<br/><br/><br/><br/>

---
<br/>

<!-- TODO: Refine -->

- Infrastructure as Code
  - Terraform
  - Modular Deployment
  - Custom naming
  - [Key Vault](key_vault.md)
  - HA Ready Infrastructure
  - Custom Images
  - IP Adressing
  - Availability Zones
  - Network Security Groups
  - DHCP
  - DNS



## Infrastructure as Code

| Feature                                  | Status                             |
| ---------------------------------------- | :--------------------------------: |
| Modular Deployment                       | ![lime](../assets/images/4s.png)   |
|   Deployment Infrastructure (Optional)   | ![lime](../assets/images/4s.png)   |
|   Library Infrastructure                 | ![Green](../assets/images/5s.png)  |
|   Workload Infrastructure                | ![green](../assets/images/5s.png)  |
|   SAP Platform Infrastructure            | ![green](../assets/images/5s.png)  |
| Naming Standard, both Default and Custom | ![green](../assets/images/5s.png)  |
| Subscription Deployment, Single          | ![green](../assets/images/5s.png)  |
| Subscription Deployment, Multiple        | ![orange](../assets/images/2s.png) |
| Support for Manual resources             | ![green](../assets/images/5s.png)  |
| Key Vault                                | ![green](../assets/images/5s.png)  |
| Regional Deployments                     | ![green](../assets/images/5s.png)  |
| DB, HANA                                 | ![green](../assets/images/5s.png)  |
| DB, Any                                  | ![green](../assets/images/5s.png)  |
| VM by SKU                                | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| DBAny                                    | ![green](../assets/images/5s.png)  |
| Disk Encryption Support                  | ![green](../assets/images/5s.png)  |
| Tagging                                  | ![green](../assets/images/5s.png)  |
| Write Acceleration                       | ![green](../assets/images/5s.png)  |
| Accelerated Networking                   | ![green](../assets/images/5s.png)  |
| IP Addressing - Static and DHCP          | ![green](../assets/images/5s.png)  |
| SSH Key Pairs                            | ![green](../assets/images/5s.png)  |


<br/><br/><br/>


## Managed Resources

| Resource                                 | Deployer                           | Library                            | Workload                           | SDU                                |
| ---------------------------------------- | :--------------------------------: | :--------------------------------: | :--------------------------------: | :--------------------------------: |
| Resource Group                           | ![green](../assets/images/5s.png)  | ![green](../assets/images/5s.png)  | ![green](../assets/images/5s.png)  | ![green](../assets/images/5s.png)  |
| Storage Account                          | ![green](../assets/images/5s.png)  | ![green](../assets/images/5s.png)  | ![green](../assets/images/5s.png)  | -                                  |
| Virtual Network                          | ![green](../assets/images/5s.png)  | -                                  | ![green](../assets/images/5s.png)  | -                                  |
| Subnet                                   | ![green](../assets/images/5s.png)  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Network Security Group                   | ![green](../assets/images/5s.png)  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Network Interface Connection (NIC)       | ![green](../assets/images/5s.png)  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Load Balancer                            | -                                  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Proximity Placement Group                | -                                  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Application Security Group               | -                                  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Availability Set                         | -                                  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Availability Zone                        | -                                  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| Public IP                                | ![green](../assets/images/5s.png)  | -                                  | -                                  | -                                  |
| DNS                                      | ![green](../assets/images/5s.png)  | -                                  | ![green](../assets/images/5s.png)  |                                    |
| VPN Gateway                              | ![red](../assets/images/1s.png)    | -                                  | ![green](../assets/images/1s.png)  | -                                  |
| VMware                                   |                                    | -                                  |                                    |                                    |
| VM                                       |                                    | -                                  |                                    |                                    |
| Disk                                     |                                    | -                                  |                                    |                                    |


<br/><br/><br/>


## Configuration as Code

| Feature                                 | Status                             |
| --------------------------------------- | :--------------------------------: |
| OS configuration, Base                  | ![orange](../assets/images/2s.png) |
| OS configuration, Base (CIS Guidelines) | ![orange](../assets/images/2s.png) |
| OS configuration, SAP Specific          | ![orange](../assets/images/2s.png) |
| Pacemaker configuration                 | ![orange](../assets/images/2s.png) |
| DB Install, HANA                        | ![yellow](../assets/images/3s.png) |
| Windows Failover configuration          | ![red](../assets/images/1s.png)    |
| SAP Application Install Framework       | ![orange](../assets/images/2s.png) |
| DB, HANA, HSR Configuration             | ![orange](../assets/images/2s.png) |


<br/><br/><br/>


## Orchestration

| Feature                                 | Status                             |
| --------------------------------------- | :--------------------------------: |
| Azure DevOps                            | ![orange](../assets/images/1s.png) |

