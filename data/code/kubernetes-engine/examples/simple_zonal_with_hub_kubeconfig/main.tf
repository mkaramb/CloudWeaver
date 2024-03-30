
provider "kind" {}

# creating a cluster with kind of the name "test-cluster" with kubernetes version v1.18.4 and two nodes
resource "kind_cluster" "test-cluster" {
  name           = "test-cluster"
  node_image     = "kindest/node:v1.18.4"
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
  }
  provisioner "local-exec" {
    command = "kubectl config set-context kind-test-cluster"
  }
}



module "hub" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/hub-legacy"
  version = "~> 30.0"

  project_id              = var.project_id
  location                = "remote"
  cluster_name            = kind_cluster.test-cluster.name
  cluster_endpoint        = kind_cluster.test-cluster.endpoint
  gke_hub_membership_name = kind_cluster.test-cluster.name
  gke_hub_sa_name         = "sa-for-kind-cluster-membership"
  use_kubeconfig          = true
  labels                  = "testlabel=usekubecontext"
}
