# [START aiplatform_create_user_managed_notebooks_instance_sample]
resource "google_notebooks_instance" "basic_instance" {
  name         = "notebooks-instance-basic"
  location     = "us-central1-a"
  machine_type = "e2-medium"

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-ent-2-9-cu113-notebooks"
  }
}
# [END aiplatform_create_user_managed_notebooks_instance_sample]
