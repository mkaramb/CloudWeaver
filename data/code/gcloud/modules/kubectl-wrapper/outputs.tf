
output "create_cmd_bin" {
  description = "The full bin path & command used on create"
  value       = module.gcloud_kubectl.create_cmd_bin
}

output "destroy_cmd_bin" {
  description = "The full bin path & command used on destroy"
  value       = module.gcloud_kubectl.destroy_cmd_bin
}

output "bin_dir" {
  description = "The full bin path of the modules executables"
  value       = module.gcloud_kubectl.bin_dir
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = module.gcloud_kubectl.wait
}
