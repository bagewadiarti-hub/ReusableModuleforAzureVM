output "vm_ids" {
  description = "Map of VM names to their resource IDs"
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm :
    key => vm.id
  }
}

output "private_ip_addresses" {
  description = "Map of VM names to their private IP addresses"
  value = {
    for key, nic in azurerm_network_interface.vm_nic :
    key => nic.private_ip_address
  }
}

output "public_ip_addresses" {
  description = "Map of VM names to their public IP addresses"
  value = {
    for key, pip in azurerm_public_ip.vm_pip :
    key => pip.ip_address
  }
}
