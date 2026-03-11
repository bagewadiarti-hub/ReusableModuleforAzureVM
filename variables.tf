variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "resource_group_name" {
  description = "Name of the main resource group"
  type        = string
  default     = "rg-tf-vms"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key content for VM login"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project   = "terraform-exercise2"
    managedby = "terraform"
  }
}

variable "dev_vms" {
  description = "Map of dev VM configurations"
  type = map(object({
    vm_size = string
  }))
  default = {
    "dev-01" = { vm_size = "Standard_L2aos_v4" }
    "dev-02" = { vm_size = "Standard_L2aos_v4" }
  }
}

variable "staging_vms" {
  description = "Map of staging VM configurations"
  type = map(object({
    vm_size = string
  }))
  default = {
    "staging-01" = { vm_size = "Standard_L2aos_v4" }
    "staging-02" = { vm_size = "Standard_L2aos_v4" }
  }
}
