# locals {
#   arm_file_path = var.enabledDDOSProtectionPlan ? "arm_templates/network/vnet_w_ddos.template.json" : "arm_templates/network/vnet.template.json"
# }

# Create the Bing Search instance via ARM Template
# data "template_file" "workflow" {
#   template = file(local.arm_file_path)
#   vars = {
#     arm_template_schema_mgmt_api = var.arm_template_schema_mgmt_api
#   }
# }

//Create the Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resourceGroupName
  tags                = var.tags
}

//Create the DDoS plan
resource "azurerm_network_ddos_protection_plan" "ddos" {
  count               = var.enabledDDOSProtectionPlan ? var.ddos_plan_id == "" ? 1 : 0 : 0
  name                = var.ddos_name
  resource_group_name = var.resourceGroupName
  location            = var.location
} 

resource "azurerm_virtual_network" "infoassist_vnet" {
  count = var.useExistingVnet ? 0 : 1
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = [var.vnetIpAddressCIDR]
  dynamic "ddos_protection_plan" {
    for_each = var.enabledDDOSProtectionPlan ? [1] : []
    content {
      enable = true
      id = var.ddos_plan_id == "" ? azurerm_network_ddos_protection_plan.ddos[0].id : var.ddos_plan_id
    }
  }
  tags                = var.tags
}

resource "azurerm_subnet" "ampls" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "ampls"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetAzureMonitorCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
}

resource "azurerm_subnet_network_security_group_association" "ampls_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.ampls[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "storageAccount" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "storageAccount"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetStorageAccountCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
}

resource "azurerm_subnet_network_security_group_association" "storageAccount_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.storageAccount[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "cosmosDb" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "cosmosDb"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetCosmosDbCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
}

resource "azurerm_subnet_network_security_group_association" "cosmosDb_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.cosmosDb[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "azureAi" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "azureAi"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetAzureAiCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.CognitiveServices"]
}

resource "azurerm_subnet_network_security_group_association" "azureAi_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.azureAi[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "keyVault" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "keyVault"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetKeyVaultCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.KeyVault"]
}

resource "azurerm_subnet_network_security_group_association" "keyVault_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.keyVault[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "app" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "app"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetAppCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.app[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "function" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "function"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetFunctionCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
}

resource "azurerm_subnet_network_security_group_association" "function_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.function[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "enrichment" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "enrichment"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetEnrichmentCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "enrichment_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.enrichment[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "integration" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "integration"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetIntegrationCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.Storage"]
  delegation {
    name = "integrationDelegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "integration_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.integration[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "aiSearch" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "aiSearch"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetSearchServiceCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
}

resource "azurerm_subnet_network_security_group_association" "aiSearch_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.aiSearch[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "azureOpenAI" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "azureOpenAI"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetAzureOpenAICIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  service_endpoints = ["Microsoft.CognitiveServices"]
}

resource "azurerm_subnet_network_security_group_association" "azureOpenAI_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.azureOpenAI[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "acr" {
  count = var.useExistingVnet ? 0 : 1
  name                 = "acr"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetACRCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
}

resource "azurerm_subnet_network_security_group_association" "acr_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.acr[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "dns" {
  count = var.useExistingVnet && !var.usePrivateDNSResolver ? 0 : 1
  name                 = "dns"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.infoassist_vnet[0].name
  address_prefixes     = [var.snetDnsCIDR]
  private_endpoint_network_policies = var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"
  private_link_service_network_policies_enabled = var.azure_environment == "AzureUSGovernment" ? false : true
  delegation {
    name = "dnsDelegation"
    service_delegation {
      name = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "dns_nsg_association" {
  count = var.useExistingVnet ? 0 : 1
  subnet_id                = azurerm_subnet.dns[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

//Create the Virtual Network
# resource "azurerm_resource_group_template_deployment" "vnet_w_subnets" {
#   resource_group_name = var.resourceGroupName
#   parameters_content = jsonencode({
#     "name"                      = { value = "${var.vnet_name}" },
#     "location"                  = { value = "${var.location}" },
#     "tags"                      = { value = var.tags },
#     "ddos_plan_id"              = { value = "${var.enabledDDOSProtectionPlan ? var.ddos_plan_id == "" ? azurerm_network_ddos_protection_plan.ddos[0].id : var.ddos_plan_id : ""}" },
#     "nsg_name"                  = { value = "${azurerm_network_security_group.nsg.name}" },
#     "vnet_CIDR"                 = { value = "${var.vnetIpAddressCIDR}" },
#     "subnet_AzureMonitor_CIDR"  = { value = "${var.snetAzureMonitorCIDR}" },
#     "subnet_AzureStorage_CIDR"  = { value = "${var.snetStorageAccountCIDR}" },
#     "subnet_AzureCosmosDB_CIDR" = { value = "${var.snetCosmosDbCIDR}" },
#     "subnet_AzureAi_CIDR"       = { value = "${var.snetAzureAiCIDR}" },
#     "subnet_KeyVault_CIDR"      = { value = "${var.snetKeyVaultCIDR}" },
#     "subnet_App_CIDR"           = { value = "${var.snetAppCIDR}" },
#     "subnet_Function_CIDR"      = { value = "${var.snetFunctionCIDR}" },
#     "subnet_Enrichment_CIDR"    = { value = "${var.snetEnrichmentCIDR}" },
#     "subnet_Integration_CIDR"   = { value = "${var.snetIntegrationCIDR}" },
#     "subnet_AiSearch_CIDR"      = { value = "${var.snetSearchServiceCIDR}" },
#     "subnet_AzureOpenAI_CIDR"   = { value = "${var.snetAzureOpenAICIDR}" },
#     "subnet_Acr_CIDR"           = { value = "${var.snetACRCIDR}" },
#     "subnet_Dns_CIDR"           = { value = "${var.snetDnsCIDR}" },
#     "privateEndpointNetworkPoliciesStatus" = { value = "${var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"}" },
#     "privateLinkServiceNetworkPoliciesStatus" = { value = "${var.azure_environment == "AzureUSGovernment" ? "Disabled" : "Enabled"}" },
#   })
#   template_content = data.template_file.workflow.template
#   # The filemd5 forces this to run when the file is changed
#   # this ensures the keys are up-to-date
#   name            = "vnet-${filemd5(local.arm_file_path)}"
#   deployment_mode = "Incremental"
# }

data "azurerm_virtual_network" "infoassist_vnet" {
  count = var.useExistingVnet ? 1 : 0
  name = var.vnet_name
  resource_group_name = var.resourceGroupName
}

data "azurerm_subnet" "ampls" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetAzureMonitorSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "storageAccount" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetStorageAccountSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "cosmosDb" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetCosmosDbSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "azureAi" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetAzureAiSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "keyVault" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetKeyVaultSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "app" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetAppSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "function" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetFunctionSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "enrichment" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetEnrichmentSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "integration" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetIntegrationSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "aiSearch" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetSearchServiceSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "azureOpenAI" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetAzureOpenAISubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "acr" {
  count = var.useExistingVnet ? 1 : 0
  name                 = var.snetACRSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

data "azurerm_subnet" "dns" {
  count = var.useExistingVnet && var.usePrivateDNSResolver ? 1 : 0
  name                 = var.snetDnsSubnetName
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resourceGroupName
}

resource "azurerm_private_dns_resolver" "private_dns_resolver" {
    count = var.usePrivateDNSResolver ? 1 : 0
    name                = var.dns_resolver_name
    location            = var.location
    resource_group_name = var.resourceGroupName
    virtual_network_id  = var.useExistingVnet ? data.azurerm_virtual_network.infoassist_vnet[0].id : azurerm_virtual_network.infoassist_vnet[0].id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "private_dns_resolver" {
    count = var.usePrivateDNSResolver ? 1 : 0
    name                        = "dns-resolver-inbound-endpoint"
    location                    = var.location
    private_dns_resolver_id     = azurerm_private_dns_resolver.private_dns_resolver[0].id

    ip_configurations {
      subnet_id                 = var.useExistingVnet ? data.azurerm_subnet.dns[0].id : azurerm_subnet.dns[0].id   
    }

    depends_on = [ azurerm_private_dns_resolver.private_dns_resolver ]
}