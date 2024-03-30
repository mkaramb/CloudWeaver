
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.tag_values
}

/******************************************
  DNS Zone IAM binding authoritative
 *****************************************/
resource "google_tags_tag_value_iam_binding" "tag_value_iam_authoritative" {
  for_each  = module.helper.set_authoritative
  tag_value = module.helper.bindings_authoritative[each.key].name
  role      = module.helper.bindings_authoritative[each.key].role
  members   = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  DNS Zone Topic IAM binding additive
 *****************************************/
resource "google_tags_tag_value_iam_member" "tag_value_iam_additive" {
  for_each  = module.helper.set_additive
  tag_value = module.helper.bindings_additive[each.key].name
  role      = module.helper.bindings_additive[each.key].role
  member    = module.helper.bindings_additive[each.key].member
}
