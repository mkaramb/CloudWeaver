
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 30.0"

  project_id                        = var.project_id
  name                              = "random-test-cluster"
  region                            = "us-west1"
  regional                          = true
  network                           = module.gke-network.network_name
  subnetwork                        = module.gke-network.subnets_names[0]
  ip_range_pods                     = module.gke-network.subnets_secondary_ranges[0][0].range_name
  ip_range_services                 = module.gke-network.subnets_secondary_ranges[0][1].range_name
  enable_private_endpoint           = true
  enable_private_nodes              = true
  master_ipv4_cidr_block            = "172.16.0.16/28"
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  service_account                   = "create"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  deletion_protection               = false

  master_authorized_networks = [
    {
      cidr_block   = module.gke-network.subnets_ips[0]
      display_name = "VPC"
    },
  ]

  node_pools = [
    {
      name               = "my-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 1
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    my-node-pool = [
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
    ]
  }

  node_pools_labels = {

    all = {

    }
    my-node-pool = {

    }
  }

  node_pools_metadata = {
    all = {}

    my-node-pool = {}

  }

  node_pools_tags = {
    all = []

    my-node-pool = []

  }
}



module "gke-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 7.5"

  project_id   = var.project_id
  network_name = "random-gke-network"

  subnets = [
    {
      subnet_name   = "random-gke-subnet"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = "us-west1"
    },
  ]

  secondary_ranges = {
    "random-gke-subnet" = [
      {
        range_name    = "random-ip-range-pods"
        ip_cidr_range = "10.1.0.0/16"
      },
      {
        range_name    = "random-ip-range-services"
        ip_cidr_range = "10.2.0.0/20"
      },
  ] }
}
