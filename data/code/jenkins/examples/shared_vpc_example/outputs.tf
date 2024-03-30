
output "jenkins_instance_name" {
  description = "The name of the Jenkins master in GCP"
  value       = module.jenkins-gce.jenkins_instance_name
}

output "jenkins_instance_zone" {
  description = "The name of the Jenkins zone in GCP"
  value       = module.jenkins-gce.jenkins_instance_zone
}

output "jenkins_instance_public_ip" {
  description = "The public IP address of the Jenkins master"
  value       = module.jenkins-gce.jenkins_instance_public_ip
}

output "jenkins_instance_initial_password" {
  sensitive   = true
  description = "The initial password for the `user` user on the Jenkins master"
  value       = module.jenkins-gce.jenkins_instance_initial_password
}

