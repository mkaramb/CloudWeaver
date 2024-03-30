
output "create_cmd_bin" {
  description = "The full bin path & command used on create"
  value       = local.create_cmd_bin
}

output "destroy_cmd_bin" {
  description = "The full bin path & command used on destroy"
  value       = local.destroy_cmd_bin
}

output "bin_dir" {
  description = "The full bin path of the modules executables"
  value       = local.gcloud_bin_path
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "downloaded" {
  description = "Whether gcloud was downloaded or not"
  value       = !local.skip_download
  depends_on  = [local.wait]
}
