
output "project_id" {
  value       = var.project_id
  description = "The project in which resources are applied."
}

output "region" {
  value       = var.region
  description = "The region in which resources are applied."
}

output "function_name" {
  value       = module.localhost_function.name
  description = "The name of the function created"
}

output "random_secret_string" {
  value       = random_string.random[0].result
  description = "The value of the secret variable."
}

output "random_file_string" {
  value       = random_string.random[1].result
  description = "The content of the terraform created file in the source directory."
}
