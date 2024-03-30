
module "pubsub_scheduled_1" {
  source  = "terraform-google-modules/scheduled-function/google"
  version = "~> 4.0"

  project_id                = var.project_id
  job_name                  = "pubsub-example"
  job_schedule              = "*/5 * * * *"
  function_entry_point      = "doSomething"
  function_source_directory = "${path.module}/function_source"
  function_name             = "testfunction-1"
  region                    = var.region
  topic_name                = "pubsub-1"
}

module "pubsub_scheduled_2" {
  source  = "terraform-google-modules/scheduled-function/google"
  version = "~> 4.0"

  project_id                = var.project_id
  function_entry_point      = "doSomething2"
  function_source_directory = "${path.module}/function_source_2"
  function_name             = "testfunction-2"
  region                    = var.region
  topic_name                = module.pubsub_scheduled_1.pubsub_topic_name
  scheduler_job             = module.pubsub_scheduled_1.scheduler_job
}
