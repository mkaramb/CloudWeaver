

###########################
## Source Bastion Host
###########################

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 6.0"

  project = module.project1.project_id
  zone    = var.zone
  members = var.members
  network = module.vpc.network_self_link
  subnet  = module.vpc.subnets_self_links[0]
  service_account_roles_supplemental = [
    "roles/bigquery.admin",
    "roles/storage.admin",
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id              = module.project1.project_id
  network_name            = "test-network"
  auto_create_subnetworks = false
  subnets = [
    {
      subnet_name   = "test-subnet"
      subnet_ip     = "10.127.0.0/20"
      subnet_region = var.region
    }
  ]
}

######################################
## Simulate Exfil to other GCP project
######################################

resource "google_project_iam_member" "bound_from_attacker" {
  project = module.project2.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${module.bastion.service_account}"
}



module "project1" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "vpc-sc-demo-project-1"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = var.folder_id
  activate_apis     = var.enabled_apis
}

module "project2" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "vpc-sc-demo-project-2"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = var.folder_id
  activate_apis     = var.enabled_apis
}



module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 7.0"

  dataset_id   = "project_1_dataset"
  dataset_name = "project_1_dataset"
  description  = "Some Cars"
  project_id   = module.project1.project_id
  location     = "US"
  tables = [
    {
      table_id = "cars",
      schema   = "fixtures/schema.json",
      time_partitioning = {
        type                     = "DAY",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = null,
      labels = {
        env = "dev"
      },
    }
  ]
  dataset_labels = {
    env = "dev"
  }
}

resource "null_resource" "load_data" {
  triggers = {
    bq_table = module.bigquery.table_names[0]
  }

  provisioner "local-exec" {
    command = <<EOF
      bq --project_id ${module.project1.project_id} \
      load \
      --location=US \
      --format=csv \
      --field_delimiter=';' \
      project_1_dataset.cars \
      gs://${google_storage_bucket.source_bucket.name}/${google_storage_bucket_object.data.output_name}
EOF
  }
}

resource "google_storage_bucket" "source_bucket" {
  project  = module.project1.project_id
  name     = "${module.project1.project_id}-source-bucket"
  location = "US"
}

resource "google_storage_bucket_object" "data" {
  name   = "cars.csv"
  source = "fixtures/cars.csv"
  bucket = google_storage_bucket.source_bucket.name
}


resource "google_storage_bucket" "target_bucket" {
  project  = module.project2.project_id
  name     = "${module.project2.project_id}-target-bucket"
  location = "US"
}



###########################
## Org Policy External IP
###########################

resource "google_organization_policy" "external_ip_policy" {
  org_id     = var.org_id
  constraint = "compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}

###########################
## VPC Service Controls
###########################

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  version     = "~> 5.0"
  parent_id   = var.org_id
  policy_name = "VPC SC Demo Policy"
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 5.0"
  policy  = module.org_policy.policy_id
  name    = "terraform_members"
  members = ["serviceAccount:${var.terraform_service_account}"]
}

module "regular_service_perimeter_1" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version             = "~> 5.0"
  policy              = module.org_policy.policy_id
  perimeter_name      = "regular_perimeter_1"
  description         = "Perimeter shielding projects"
  resources           = [module.project1.project_number]
  access_levels       = [module.access_level_members.name]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
}

