
output "cloudbuild_plan_trigger_id" {
  description = "Trigger used for running TF plan"
  value       = google_cloudbuild_trigger.triggers["plan"].id
}

output "cloudbuild_apply_trigger_id" {
  description = "Trigger used for running TF apply"
  value       = google_cloudbuild_trigger.triggers["apply"].id
}

output "cloudbuild_sa" {
  description = "SA used by Cloud Build triggers"
  value       = local.cloudbuild_sa
}

output "state_bucket" {
  description = "Bucket for storing TF state"
  value       = local.state_bucket_self_link
}

output "logs_bucket" {
  description = "Bucket for storing TF logs"
  value       = module.log_bucket.bucket.self_link
}

output "artifacts_bucket" {
  description = "Bucket for storing TF plans"
  value       = module.artifacts_bucket.bucket.self_link
}
