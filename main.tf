# root/main.tf
# Calls the VM module for dev and staging environments

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateazublobtest123" # Replace with your actual storage account
    container_name       = "tfstate"
    key                  = "exercise2/terraform.tfstate" # Different key from Exercise 1
  }
}

provider "azurerm" {
  features {}
}

# ─────────────────────────────────────────────
# Resource Group
# ─────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.common_tags
}

# ─────────────────────────────────────────────
# Networking (shared VNet + Subnet for both envs)
# ─────────────────────────────────────────────
resource "azurerm_virtual_network" "main" {
  name                = "vnet-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.common_tags
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-main"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ─────────────────────────────────────────────
# DEV Environment VMs (calls module)
# ─────────────────────────────────────────────
module "dev_vms" {
  source = "./modules/vm"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key

  vms = var.dev_vms # map passed from variables

  tags = merge(var.common_tags, {
    environment = "dev"
  })
}

# ─────────────────────────────────────────────
# STAGING Environment VMs (calls same module)
# ─────────────────────────────────────────────
module "staging_vms" {
  source = "./modules/vm"

  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.main.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key

  vms = var.staging_vms # different map for staging

  tags = merge(var.common_tags, {
    environment = "staging"
  })
}
