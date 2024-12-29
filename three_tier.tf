# Provider Configuration
provider "azurerm" {
  features {}
  subscription_id = "69c9604f-9a86-42c3-8c12-530a6d413a27"
}

# Resource Group
resource "azurerm_resource_group" "three_tier_rg" {
  name     = "three-tier-app-rg"
  location = "East US"
}

# Network Configuration
resource "azurerm_virtual_network" "main_vnet" {
  name                = "three-tier-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
}

# Subnets
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = azurerm_resource_group.three_tier_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = "backend-subnet"
  resource_group_name  = azurerm_resource_group.three_tier_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "database_subnet" {
  name                 = "database-subnet"
  resource_group_name  = azurerm_resource_group.three_tier_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Frontend App Service Plan (Minimal SKU)
resource "azurerm_service_plan" "frontend_plan" {
  name                = "frontend-app-plan"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
  os_type             = "Linux"
  sku_name            = "B1"  # Basic tier, lowest cost option
}

# Frontend Web App
resource "azurerm_linux_web_app" "frontend_app" {
  name                = "three-tier-frontend-app"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
  service_plan_id     = azurerm_service_plan.frontend_plan.id

  site_config {
    always_on = false  # Disabled to reduce costs
  }
}

# Backend App Service Plan
resource "azurerm_service_plan" "backend_plan" {
  name                = "backend-app-plan"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
  os_type             = "Linux"
  sku_name            = "B1"  # Basic tier, lowest cost option
}

# Backend Web App
resource "azurerm_linux_web_app" "backend_app" {
  name                = "three-tier-backend-app"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
  service_plan_id     = azurerm_service_plan.backend_plan.id

  site_config {
    always_on = false  # Disabled to reduce costs
  }
}

# Database (Minimal SKU)
resource "azurerm_postgresql_server" "database" {
  name                = "three-tier-postgresql-server"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name

  sku_name   = "B_Gen5_1"  # Basic, single core
  storage_mb = 5120        # Minimum storage
  
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "psqladmin"
  administrator_login_password = "YourStrongPasswordHere!"
  version                      = "11"
  ssl_enforcement_enabled      = true
}

# Network Security Groups
resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "frontend-nsg"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
}

resource "azurerm_network_security_group" "backend_nsg" {
  name                = "backend-nsg"
  location            = azurerm_resource_group.three_tier_rg.location
  resource_group_name = azurerm_resource_group.three_tier_rg.name
}

# Subnet-NSG Associations
resource "azurerm_subnet_network_security_group_association" "frontend_nsg_assoc" {
  subnet_id                 = azurerm_subnet.frontend_subnet.id
  network_security_group_id = azurerm_network_security_group.frontend_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "backend_nsg_assoc" {
  subnet_id                 = azurerm_subnet.backend_subnet.id
  network_security_group_id = azurerm_network_security_group.backend_nsg.id
}