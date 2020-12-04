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
  default     = "sap_anydb"
}

variable "max_timeout" {
  description = "Maximum time allowed to spend for curl"
  default     = 10
}
