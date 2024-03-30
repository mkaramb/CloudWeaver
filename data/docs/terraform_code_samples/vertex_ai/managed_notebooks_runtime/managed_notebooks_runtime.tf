# [START aiplatform_create_managed_notebooks_runtime_sample]
resource "google_notebooks_runtime" "basic_runtime" {
  name     = "notebooks-runtime-basic"
  location = "us-central1"

  access_config {
    access_type   = "SINGLE_USER"
    runtime_owner = "admin@hashicorptest.com"
  }

  virtual_machine {
    virtual_machine_config {
      machine_type = "n1-standard-4"
      data_disk {
        initialize_params {
          disk_size_gb = "100"
          disk_type    = "PD_STANDARD"
        }
      }
    }
  }
}
# [END aiplatform_create_managed_notebooks_runtime_sample]

