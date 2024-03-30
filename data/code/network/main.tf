
/******************************************
	VPC configuration
 *****************************************/
module "vpc" {
  source                                    = "./modules/vpc"
  network_name                              = var.network_name
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  project_id                                = var.project_id
  description                               = var.description
  shared_vpc_host                           = var.shared_vpc_host
  delete_default_internet_gateway_routes    = var.delete_default_internet_gateway_routes
  mtu                                       = var.mtu
  enable_ipv6_ula                           = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}

/******************************************
	Subnet configuration
 *****************************************/
module "subnets" {
  source           = "./modules/subnets"
  project_id       = var.project_id
  network_name     = module.vpc.network_name
  subnets          = var.subnets
  secondary_ranges = var.secondary_ranges
}

/******************************************
	Routes
 *****************************************/
module "routes" {
  source            = "./modules/routes"
  project_id        = var.project_id
  network_name      = module.vpc.network_name
  routes            = var.routes
  module_depends_on = [module.subnets.subnets]
}

/******************************************
	Firewall rules
 *****************************************/
locals {
  rules = [
    for f in var.firewall_rules : {
      name                    = f.name
      direction               = f.direction
      disabled                = lookup(f, "disabled", null)
      priority                = lookup(f, "priority", null)
      description             = lookup(f, "description", null)
      ranges                  = lookup(f, "ranges", null)
      source_tags             = lookup(f, "source_tags", null)
      source_service_accounts = lookup(f, "source_service_accounts", null)
      target_tags             = lookup(f, "target_tags", null)
      target_service_accounts = lookup(f, "target_service_accounts", null)
      allow                   = lookup(f, "allow", [])
      deny                    = lookup(f, "deny", [])
      log_config              = lookup(f, "log_config", null)
    }
  ]
}

module "firewall_rules" {
  source        = "./modules/firewall-rules"
  project_id    = var.project_id
  network_name  = module.vpc.network_name
  rules         = local.rules
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}
