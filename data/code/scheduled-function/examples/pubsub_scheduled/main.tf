
resource "random_pet" "main" {
  length    = 2
  separator = "-"
}

module "pubsub_scheduled_example" {
  source  = "terraform-google-modules/scheduled-function/google"
  version = "~> 4.0"

  project_id                = var.project_id
  job_name                  = "pubsub-example-${random_pet.main.id}"
  job_schedule              = "*/5 * * * *"
  function_entry_point      = "doSomething"
  function_source_directory = "${path.module}/function_source"
  function_name             = "testfunction-${random_pet.main.id}"
  region                    = "us-central1"
  topic_name                = "pubsub_example_topic_${random_pet.main.id}"
}
