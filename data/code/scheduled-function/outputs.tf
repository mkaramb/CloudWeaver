
output "name" {
  value       = length(google_cloud_scheduler_job.job) > 0 ? google_cloud_scheduler_job.job[0].name : null
  description = "The name of the job created"
}

output "scheduler_job" {
  value       = length(google_cloud_scheduler_job.job) > 0 ? google_cloud_scheduler_job.job[0] : null
  description = "The Cloud Scheduler job instance"
}

output "pubsub_topic_name" {
  value       = var.scheduler_job == null ? module.pubsub_topic.topic : var.topic_name
  description = "PubSub topic name"
}
