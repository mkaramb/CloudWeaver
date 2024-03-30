
variable "project_id" {
  description = "SRE Project id"
}

variable "team1_project_id" {
  description = "Team 1 project id"
}

variable "team2_project_id" {
  description = "Team 2 project id"
}

variable "gcr_project_id" {
  description = "Google Container registry project where image is hosted"
  default     = "slo-generator-ci-a2b4"
}

variable "schedule" {
  description = "Cron-like Cloud Scheduler schedule"
  default     = "* * * * */1"
}

variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "pubsub_topic_name" {
  description = "PubSub topic name"
  default     = "slo-export"
}

variable "bigquery_dataset_name" {
  description = "BigQuery dataset to hold SLO reports"
  default     = "slo"
}

variable "slo_generator_version" {
  description = "slo-generator image version"
  default     = "latest"
}
