
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.pubsub_subscriptions
}

/******************************************
  PubSub Subscription IAM binding authoritative
 *****************************************/
resource "google_pubsub_subscription_iam_binding" "pubsub_subscription_iam_authoritative" {
  for_each     = module.helper.set_authoritative
  project      = var.project
  subscription = module.helper.bindings_authoritative[each.key].name
  role         = module.helper.bindings_authoritative[each.key].role
  members      = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  PubSub Subscription IAM binding additive
 *****************************************/
resource "google_pubsub_subscription_iam_member" "pubsub_subscription_iam_additive" {
  for_each     = module.helper.set_additive
  project      = var.project
  subscription = module.helper.bindings_additive[each.key].name
  role         = module.helper.bindings_additive[each.key].role
  member       = module.helper.bindings_additive[each.key].member
}
