
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.tag_keys
}

/******************************************
  DNS Zone IAM binding authoritative
 *****************************************/
resource "google_tags_tag_key_iam_binding" "tag_key_iam_authoritative" {
  for_each = module.helper.set_authoritative
  tag_key  = module.helper.bindings_authoritative[each.key].name
  role     = module.helper.bindings_authoritative[each.key].role
  members  = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  DNS Zone Topic IAM binding additive
 *****************************************/
resource "google_tags_tag_key_iam_member" "tag_key_iam_additive" {
  for_each = module.helper.set_additive
  tag_key  = module.helper.bindings_additive[each.key].name
  role     = module.helper.bindings_additive[each.key].role
  member   = module.helper.bindings_additive[each.key].member
}
