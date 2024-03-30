
locals {
  restart_policy_enum = tomap({
    "onfailure" : "OnFailure"
    "unlessstopped" : "UnlessStopped"
    "always" : "Always"
    "never" : "Never"
  })

  cos_image_name   = var.cos_image_name
  cos_image_family = var.cos_image_name == null ? "cos-${var.cos_image_family}" : null
  cos_project      = var.cos_project

  spec = {
    spec = {
      containers    = [var.container]
      volumes       = var.volumes
      restartPolicy = lookup(local.restart_policy_enum, lower(var.restart_policy), null)
    }
  }

  spec_as_yaml = yamlencode(local.spec)
}

data "google_compute_image" "coreos" {
  name    = local.cos_image_name
  family  = local.cos_image_family
  project = local.cos_project
}
