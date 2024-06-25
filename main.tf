resource "azurerm_resource_group" "oneclick_rg" {  
  name     = var.resourceGroupName  
  location = var.location  
}  
  
module "publicVnet" {  
  source              = "Azure/vnet/azurerm"  
  version             = "4.1.0"  
  resource_group_name = var.resourceGroupName  
  vnet_location       = var.location  
  vnet_name           = var.vnet_name  
  use_for_each        = true  
  address_space       = var.vnet_address_space  
  subnet_names        = var.subnet_names  
  subnet_prefixes     = var.subnet_prefixes  
  
  depends_on = [  
    azurerm_resource_group.oneclick_rg  
  ]  
}  
  
resource "azurerm_network_security_group" "app_nsg" {  
  name                = "vln-vnet-nsg"  
  location            = var.location  
  resource_group_name = var.resourceGroupName  
  
  security_rule {  
    name                       = "Allow_HTTP"  
    priority                   = 200  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "80"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
  
  security_rule {  
    name                       = "Allow_HTTPS"  
    priority                   = 201  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "443"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
  
  security_rule {  
    name                       = "Allow_SSH"  
    priority                   = 203  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "22"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
  
  security_rule {  
    name                       = "AllowNatOutbound"  
    priority                   = 100  
    direction                  = "Outbound"  
    access                     = "Allow"  
    protocol                   = "*"  
    source_port_range          = "*"  
    destination_port_range     = "*"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  
  
  depends_on = [  
    azurerm_resource_group.oneclick_rg  
  ]  
}  
  
resource "azurerm_subnet_network_security_group_association" "nsg_association_subnet1" {  
  subnet_id                 = module.publicVnet.vnet_subnets[0]  
  network_security_group_id = azurerm_network_security_group.app_nsg.id  
  
  depends_on = [  
    azurerm_network_security_group.app_nsg,  
    module.publicVnet  
  ]  
}  
  
resource "azurerm_subnet_network_security_group_association" "nsg_association_subnet2" {  
  subnet_id                 = module.publicVnet.vnet_subnets[1]  
  network_security_group_id = azurerm_network_security_group.app_nsg.id  
  
  depends_on = [  
    azurerm_network_security_group.app_nsg,  
    module.publicVnet  
  ]  
}  
  
resource "azurerm_container_registry" "acr" {  
  name                = replace(var.acr_name, "-", "")  
  location            = var.location  
  resource_group_name = var.resourceGroupName  
  admin_enabled       = true  
  sku                 = "Standard"  
  public_network_access_enabled = true  
  
  depends_on = [  
    azurerm_resource_group.oneclick_rg  
  ]  
}  
  
module "aks" {  
  source                               = "Azure/aks/azurerm"  
  version                              = "7.5.0"  
  resource_group_name                  = var.resourceGroupName  
  private_cluster_enabled              = false  
  cluster_name                         = var.aks_cluster_name  
  location                             = var.location  
  agents_availability_zones            = var.aks_agents_availability_zones  
  role_based_access_control_enabled    = true  
  rbac_aad                             = false  
  vnet_subnet_id                       = module.publicVnet.vnet_subnets[0]  
  network_policy                       = "azure"  
  net_profile_dns_service_ip           = var.net_profile_dns_service_ip  
  net_profile_service_cidr             = var.net_profile_service_cidr  
  network_plugin                       = "azure"  
  cluster_log_analytics_workspace_name = "oneclick-aks-log-workspace"  
  log_analytics_workspace_enabled      = false  
  agents_min_count                     = 2  
  agents_max_count                     = 3  
  agents_count                         = null  
  agents_pool_name                     = "custompool"  
  agents_size                          = "Standard_B4ms"  
  enable_auto_scaling                  = true  
  key_vault_secrets_provider_enabled   = false  
  storage_profile_blob_driver_enabled  = false  
  storage_profile_disk_driver_enabled  = true  
  prefix                               = var.aks_prefix  
  attached_acr_id_map = {  
    acr = azurerm_container_registry.acr.id  
  }  
  
  depends_on = [  
    azurerm_container_registry.acr,  
    azurerm_resource_group.oneclick_rg,  
    module.publicVnet  
  ]  
}  
