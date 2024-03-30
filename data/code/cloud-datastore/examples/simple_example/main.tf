
module "datastore" {
  source  = "terraform-google-modules/cloud-datastore/google"
  version = "~> 2.0"

  project    = var.project
  indexes    = file(var.indexes_file_path)
  depends_on = [time_sleep.wait_120_seconds]
}

resource "google_app_engine_application" "app" {
  project     = var.project
  location_id = var.location_id
}

resource "time_sleep" "wait_120_seconds" {
  # sleep 120s for App to get created
  depends_on      = [google_app_engine_application.app]
  create_duration = "120s"
}
