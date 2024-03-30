
output "jenkins_instance_zone" {
  description = "The zone in which Jenkins is running"
  value       = var.jenkins_instance_zone
}

output "jenkins_instance_name" {
  description = "The name of the running Jenkins instance"
  value       = var.jenkins_instance_name
}

output "jenkins_instance_service_account_email" {
  description = "The email address of the created service account"
  value       = google_service_account.jenkins.email
}

output "jenkins_instance_public_ip" {
  description = "The public IP of the Jenkins instance"
  value       = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}

output "jenkins_instance_initial_password" {
  sensitive   = true
  description = "The initial password assigned to the Jenkins instance's `user` username"
  value       = local.jenkins_password
}

