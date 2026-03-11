# root/outputs.tf

output "dev_vm_ids" {
  description = "Dev VM resource IDs"
  value       = module.dev_vms.vm_ids
}

output "dev_private_ips" {
  description = "Dev VM private IP addresses"
  value       = module.dev_vms.private_ip_addresses
}

output "dev_public_ips" {
  description = "Dev VM public IP addresses"
  value       = module.dev_vms.public_ip_addresses
}

output "staging_vm_ids" {
  description = "Staging VM resource IDs"
  value       = module.staging_vms.vm_ids
}

output "staging_private_ips" {
  description = "Staging VM private IP addresses"
  value       = module.staging_vms.private_ip_addresses
}

output "staging_public_ips" {
  description = "Staging VM public IP addresses"
  value       = module.staging_vms.public_ip_addresses
}
