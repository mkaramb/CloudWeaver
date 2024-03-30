
output "service_url" {
  value = local.service_url
}

output "service_name" {
  value = var.create_service ? google_cloud_run_service.service[0].name : ""
}

output "bucket_name" {
  value = local.bucket_name
}

output "service_account_email" {
  value = local.service_account_email
}

output "authorized_members" {
  value = google_cloud_run_service_iam_member.run-invokers[*].member
}
