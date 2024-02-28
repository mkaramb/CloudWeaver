output "project_ids" {
  value = local.project_ids
}

output "sa_key" {
  value     = google_service_account_key.int_test.private_key
  sensitive = true
}
