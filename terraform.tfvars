# terraform.tfvars
# Copy this file and fill in your actual values
# DO NOT commit real values to GitHub — use Jenkins credentials instead

location            = "westus2"
resource_group_name = "rg-tf-vms"
admin_username      = "azureuser"

# ssh_public_key is passed via Jenkins TF_VAR_ssh_public_key env variable
# Do NOT put your real SSH key here

common_tags = {
  project   = "ReusableModuleforAzureVM"
  managedby = "terraform"
  owner     = "Arti"
}

dev_vms = {
  "dev-01" = { vm_size = "Standard_L2aos_v4" }
  "dev-02" = { vm_size = "Standard_L2aos_v4" }
}

staging_vms = {
  "staging-01" = { vm_size = "Standard_L2aos_v4" }
  "staging-02" = { vm_size = "Standard_L2aos_v4" }
}
