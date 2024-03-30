output "service_account" {
  description = "The email for the service account created for the bastion host"
  value       = local.service_account_email
}

output "hostname" {
  description = "Host name of the bastion"
  value       = var.name
}

output "ip_address" {
  description = "Internal IP address of the bastion host"
  value       = try((var.create_instance_from_template ? google_compute_instance_from_template.bastion_vm[0].network_interface[0].network_ip : ""), "")
}

output "self_link" {
  description = "Self link of the bastion host"
  value       = try((var.create_instance_from_template ? google_compute_instance_from_template.bastion_vm[0].self_link : ""), "")
}

output "instance_template" {
  description = "Self link of the bastion instance template for use with a MIG"
  value       = module.instance_template.self_link
}
