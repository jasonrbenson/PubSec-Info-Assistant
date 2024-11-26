output "nsg_name" {
  value = azurerm_network_security_group.nsg.name  
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "vnet_name" {
  value = var.vnet_name
}

output "vnet_id" {
  value = var.useExistingVnet ? data.azurerm_virtual_network.infoassist_vnet[0].id : azurerm_virtual_network.infoassist_vnet[0].id
}

output "snetAmpls_name" {
  value =  var.useExistingVnet ? data.azurerm_subnet.ampls[0].name : azurerm_subnet.ampls[0].name
}

output "snetAmpls_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.ampls[0].id : azurerm_subnet.ampls[0].id
}

output "snetStorage_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.storageAccount[0].name : azurerm_subnet.storageAccount[0].name
}

output "snetStorage_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.storageAccount[0].id : azurerm_subnet.storageAccount[0].id
}

output "snetCosmosDb_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.cosmosDb[0].name : azurerm_subnet.cosmosDb[0].name
}

output "snetCosmosDb_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.cosmosDb[0].id : azurerm_subnet.cosmosDb[0].id
}

output "snetAzureAi_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.azureAi[0].id : azurerm_subnet.azureAi[0].id
}

output "snetAzureAi_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.azureAi[0].name : azurerm_subnet.azureAi[0].name
}

output "snetKeyVault_id" {
  description = "The ID of the subnet dedicated for the Key Vault"
  value = var.useExistingVnet ? data.azurerm_subnet.keyVault[0].id : azurerm_subnet.keyVault[0].id
}

output "snetKeyVault_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.keyVault[0].name : azurerm_subnet.keyVault[0].name
}

output "snetACR_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.acr[0].name : azurerm_subnet.acr[0].name
}

output "snetACR_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.acr[0].id : azurerm_subnet.acr[0].id  
}

output "snetApp_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.app[0].id : azurerm_subnet.app[0].id
}

output "snetApp_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.app[0].name : azurerm_subnet.app[0].name
}

output "snetFunction_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.function[0].id : azurerm_subnet.function[0].id
}

output "snetFunction_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.function[0].name : azurerm_subnet.function[0].name
}

output "snetEnrichment_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.enrichment[0].name : azurerm_subnet.enrichment[0].name
}

output "snetEnrichment_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.enrichment[0].id : azurerm_subnet.enrichment[0].id
}

output "snetIntegration_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.integration[0].id : azurerm_subnet.integration[0].id
}

output "snetIntegration_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.integration[0].name : azurerm_subnet.integration[0].name
}

output "snetSearch_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.aiSearch[0].name : azurerm_subnet.aiSearch[0].name
}

output "snetSearch_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.aiSearch[0].id : azurerm_subnet.aiSearch[0].id
}

output "snetAzureOpenAI_id" {
  value = var.useExistingVnet ? data.azurerm_subnet.azureOpenAI[0].id : azurerm_subnet.azureOpenAI[0].id
}

output "snetAzureOpenAI_name" {
  value = var.useExistingVnet ? data.azurerm_subnet.azureOpenAI[0].name : azurerm_subnet.azureOpenAI[0].name
}

output "ddos_plan_id" {
  value = var.enabledDDOSProtectionPlan ? var.ddos_plan_id == "" ? azurerm_network_ddos_protection_plan.ddos[0].id : var.ddos_plan_id : ""
}

output "dns_private_resolver_ip" {
  value = var.usePrivateDNSResolver ? azurerm_private_dns_resolver_inbound_endpoint.private_dns_resolver.ip_configurations[0].private_ip_address : ""
}