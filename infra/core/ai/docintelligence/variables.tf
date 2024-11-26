variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "" 
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "customSubDomainName" {
  type    = string
}

variable "sku" {
  type = object({
    name = string
  })
  default = {
    name = "S0"
  }
}

variable "resourceGroupName" {
  type    = string
  default = ""
}

variable "key_vault_name" { 
  type = string
}

variable "is_secure_mode" {
  type = bool
  default = false
}


variable "private_dns_zone_ids" {
  type = set(string)
}

variable "create_private_dns" {
  type    = bool
  default = true
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "arm_template_schema_mgmt_api" {
  type = string
}