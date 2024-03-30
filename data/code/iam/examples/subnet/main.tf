
locals {
  subnet_one_full = format(
    "projects/%s/regions/%s/subnetworks/%s",
    var.project,
    var.region,
    var.subnet_one,
  )
  subnet_two_full = format(
    "projects/%s/regions/%s/subnetworks/%s",
    var.project,
    var.region,
    var.subnet_two,
  )
}

/******************************************
  Module pubsub_subscription_iam_binding calling
 *****************************************/
module "subnet_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/subnets_iam"
  version = "~> 7.0"

  subnets        = [local.subnet_one_full, local.subnet_two_full]
  subnets_region = var.region
  project        = var.project
  mode           = "authoritative"
  bindings = {
    "roles/compute.networkUser" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/compute.networkViewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
