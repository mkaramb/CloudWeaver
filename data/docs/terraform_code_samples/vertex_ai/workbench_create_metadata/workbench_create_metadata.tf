# [START aiplatform_workbench_create_metadata]
resource "google_workbench_instance" "default" {
  name     = "workbench-instance-example"
  location = "us-central1-a"

  gce_setup {
    machine_type = "n1-standard-1"
    vm_image {
      project = "deeplearning-platform-release"
      family  = "tf-latest-gpu"
    }
    metadata = {
      key = "value"
    }
  }
}
# [END aiplatform_workbench_create_metadata]
