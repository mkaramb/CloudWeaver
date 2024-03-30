
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.managed_zones
}

/******************************************
  DNS Zone IAM binding authoritative
 *****************************************/
resource "google_dns_managed_zone_iam_binding" "dns_zone_iam_authoritative" {
  for_each     = module.helper.set_authoritative
  project      = var.project
  managed_zone = module.helper.bindings_authoritative[each.key].name
  role         = module.helper.bindings_authoritative[each.key].role
  members      = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  DNS Zone Topic IAM binding additive
 *****************************************/
resource "google_dns_managed_zone_iam_member" "dns_zone_iam_additive" {
  for_each     = module.helper.set_additive
  project      = var.project
  managed_zone = module.helper.bindings_additive[each.key].name
  role         = module.helper.bindings_additive[each.key].role
  member       = module.helper.bindings_additive[each.key].member
}
