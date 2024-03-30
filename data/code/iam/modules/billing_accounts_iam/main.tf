
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.billing_account_ids
}

/******************************************
  Billing Account IAM binding authoritative
 *****************************************/
resource "google_billing_account_iam_binding" "billing_account_iam_authoritative" {
  for_each           = module.helper.set_authoritative
  billing_account_id = module.helper.bindings_authoritative[each.key].name
  role               = module.helper.bindings_authoritative[each.key].role
  members            = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  Billing Account IAM binding additive
 *****************************************/
resource "google_billing_account_iam_member" "billing_account_iam_additive" {
  for_each           = module.helper.set_additive
  billing_account_id = module.helper.bindings_additive[each.key].name
  role               = module.helper.bindings_additive[each.key].role
  member             = module.helper.bindings_additive[each.key].member
}
