
terraform {
  required_version = ">= 0.12"
}

provider "archive" {
}

provider "google" {
}

provider "random" {
}

resource "random_pet" "main" {
  separator = "-"
}

module "event_project_log_entry" {
  source  = "terraform-google-modules/event-function/google//modules/event-project-log-entry"
  version = "~> 3.0"

  filter     = "resource.type=\"gce_instance\" jsonPayload.event_subtype=\"compute.instances.insert\" jsonPayload.event_type=\"GCE_OPERATION_DONE\""
  name       = random_pet.main.id
  project_id = var.project_id
}

module "localhost_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 3.0"

  description = "Deletes VMs created with disks not encrypted with CMEK"
  entry_point = "ReceiveMessage"
  runtime     = "go111"
  timeout_s   = "240"

  event_trigger    = module.event_project_log_entry.function_event_trigger
  name             = random_pet.main.id
  project_id       = var.project_id
  region           = var.region
  source_directory = "${path.module}/function_source"
  max_instances    = 3000
}
