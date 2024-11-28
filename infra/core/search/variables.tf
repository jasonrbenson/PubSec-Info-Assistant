variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "pe_location" {
  type = string
  
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "sku" {
  type = object({
    name = string
  })
  default = {
    name = "standard"
  }
}

variable "authOptions" {
  type = map(string)
  default = {}
}

variable "semanticSearch" {
  type = string
  default = "disabled"
}

variable "resourceGroupName" {
  type    = string
}

variable "azure_search_domain" {
  type = string  
}

variable "key_vault_name" { 
  type = string
}

variable "is_secure_mode" {
  type = bool
  default = false
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
  default = ""
}

variable "subnet_id" {
  type = string
}

variable "private_dns_zone_ids" {
  type = set(string)
}

variable "create_private_dns" {
  type    = bool
  default = true
}
variable "arm_template_schema_mgmt_api" {
  type = string
}