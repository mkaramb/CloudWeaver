
module "redis_cluster" {
  source  = "terraform-google-modules/memorystore/google//modules/redis-cluster"
  version = "~> 8.0"

  name    = "test-redis-cluster"
  project = var.project_id
  region  = "us-central1"
  network = ["projects/${var.project_id}/global/networks/${local.network_name}"]

  service_connection_policies = {
    test-net-redis-cluster-scp = {
      network_name    = local.network_name
      network_project = var.project_id
      subnet_names = [
        "subnet-100",
        "subnet-101",
      ]
    }
  }
  depends_on = [module.test_vpc]
}



locals {
  network_name = "test-net-redis-cluster"
}

module "test_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = local.network_name
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-100"
      subnet_ip     = "10.10.100.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name   = "subnet-101"
      subnet_ip     = "10.10.101.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name   = "subnet-102"
      subnet_ip     = "10.10.102.0/24"
      subnet_region = "us-east1"
    },
  ]
}



## Enable Service Identity and assign Network Connectivity Service Agent role
## https://cloud.google.com/vpc/docs/configure-service-connection-policies#configure-service-project

resource "google_project_service_identity" "network_connectivity_sa" {
  provider = google-beta

  project = var.project_id
  service = "networkconnectivity.googleapis.com"
}

resource "google_project_iam_member" "network_connectivity_sa" {
  project = var.project_id
  role    = "roles/networkconnectivity.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.network_connectivity_sa.email}"
}
