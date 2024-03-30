
module "gce-lb-fr" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "~> 4.0"
  region       = var.region
  network      = var.network
  project      = var.project
  name         = "group1-lb"
  service_port = local.named_ports[0].port
  target_tags  = ["allow-group1"]
}

module "gce-ilb" {
  source  = "terraform-google-modules/lb-internal/google"
  version = "~> 5.0"

  project      = var.project
  region       = var.region
  name         = "group-ilb"
  ports        = [local.named_ports[0].port]
  source_tags  = ["allow-group1"]
  target_tags  = ["allow-group2", "allow-group3"]
  health_check = local.health_check

  backends = [
    {
      group       = module.mig2.instance_group
      description = ""
      failover    = false
    },
    {
      group       = module.mig3.instance_group
      description = ""
      failover    = false
    },
  ]
}



locals {
  named_ports = [{
    name = "http"
    port = 80
  }]
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
    enable_log          = false
  }
}



module "instance_template1" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 10.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/nginx_upstream.sh.tpl", { UPSTREAM = module.gce-ilb.ip_address })
  tags               = ["allow-group1"]
}

module "instance_template2" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 10.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/gceme.sh.tpl", { PROXY_PATH = "" })
  tags               = ["allow-group2"]
}

module "instance_template3" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 10.0"
  project_id         = var.project
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account
  startup_script     = templatefile("${path.module}/gceme.sh.tpl", { PROXY_PATH = "" })
  tags               = ["allow-group3"]
}

module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 10.0"
  project_id        = var.project
  region            = var.region
  target_pools      = [module.gce-lb-fr.target_pool]
  instance_template = module.instance_template1.self_link
  hostname          = "mig1"
  named_ports       = local.named_ports
}

module "mig2" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 10.0"
  project_id        = var.project
  region            = var.region
  hostname          = "mig2"
  instance_template = module.instance_template2.self_link
  named_ports       = local.named_ports
}

module "mig3" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 10.0"
  project_id        = var.project
  region            = var.region
  hostname          = "mig3"
  instance_template = module.instance_template3.self_link
  named_ports       = local.named_ports
}
