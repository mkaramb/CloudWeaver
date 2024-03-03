# [START aiplatform_workbench_basic_gpu_instance]
resource "google_workbench_instance" "default" {
  name     = "workbench-instance-example"
  location = "us-central1-a"

  gce_setup {
    machine_type = "n1-standard-1"
    accelerator_configs {
      type       = "NVIDIA_TESLA_T4"
      core_count = 1
    }
    vm_image {
      project = "deeplearning-platform-release"
      family  = "tf-latest-gpu"
    }
  }
}
# [END aiplatform_workbench_basic_gpu_instance]
