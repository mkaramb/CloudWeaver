
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source               = "../helper"
  bindings             = var.bindings
  mode                 = var.mode
  entities             = var.kms_key_rings
  conditional_bindings = var.conditional_bindings
}

/******************************************
  KMS Key Ring IAM binding authoritative
 *****************************************/
resource "google_kms_key_ring_iam_binding" "kms_key_ring_iam_authoritative" {
  for_each    = module.helper.set_authoritative
  key_ring_id = module.helper.bindings_authoritative[each.key].name
  role        = module.helper.bindings_authoritative[each.key].role
  members     = module.helper.bindings_authoritative[each.key].members
  dynamic "condition" {
    for_each = module.helper.bindings_authoritative[each.key].condition.title == "" ? [] : [module.helper.bindings_authoritative[each.key].condition]
    content {
      title       = module.helper.bindings_authoritative[each.key].condition.title
      description = module.helper.bindings_authoritative[each.key].condition.description
      expression  = module.helper.bindings_authoritative[each.key].condition.expression
    }
  }
}

/******************************************
  KMS Key Ring IAM binding additive
 *****************************************/
resource "google_kms_key_ring_iam_member" "kms_key_ring_iam_additive" {
  for_each    = module.helper.set_additive
  key_ring_id = module.helper.bindings_additive[each.key].name
  role        = module.helper.bindings_additive[each.key].role
  member      = module.helper.bindings_additive[each.key].member
  dynamic "condition" {
    for_each = module.helper.bindings_additive[each.key].condition.title == "" ? [] : [module.helper.bindings_additive[each.key].condition]
    content {
      title       = module.helper.bindings_additive[each.key].condition.title
      description = module.helper.bindings_additive[each.key].condition.description
      expression  = module.helper.bindings_additive[each.key].condition.expression
    }
  }
}
