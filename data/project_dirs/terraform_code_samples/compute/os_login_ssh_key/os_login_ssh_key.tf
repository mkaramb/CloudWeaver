# [START compute_os_login_ssh_key_parent_tag]
# [START compute_os_login_ssh_public_key]
data "google_client_openid_userinfo" "me" {
}

resource "google_os_login_ssh_public_key" "default" {
  user = data.google_client_openid_userinfo.me.email
  key  = file("id_rsa.pub") # path/to/ssl/id_rsa.pub
}
# [END compute_os_login_ssh_public_key]


# [START compute_os_login_metadata_based_ssh_keys]
resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = <<EOF
      dev:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT dev
      test:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT test
    EOF
  }
}
# [END compute_os_login_metadata_based_ssh_keys]

# [START compute_os_login_google_compute_instance_ssh_keys]
resource "google_compute_instance" "default" {
  name         = "my-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-1404-trusty-v20160627"
    }
  }

  # Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    "ssh-keys" = <<EOT
      dev:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT dev
      test:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT test
     EOT
  }
}
# [END compute_os_login_google_compute_instance_ssh_keys]
# [END compute_os_login_ssh_key_parent_tag]
