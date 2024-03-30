
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.bigquery_datasets
}

/******************************************
  BigQuery Topic IAM binding authoritative
 *****************************************/
resource "google_bigquery_dataset_iam_binding" "bigquery_dataset_iam_authoritative" {
  for_each   = module.helper.set_authoritative
  project    = var.project
  dataset_id = module.helper.bindings_authoritative[each.key].name
  role       = module.helper.bindings_authoritative[each.key].role
  members    = module.helper.bindings_authoritative[each.key].members
}

/******************************************
  BigQuery Topic IAM binding additive
 *****************************************/
resource "google_bigquery_dataset_iam_member" "bigquery_dataset_iam_additive" {
  for_each   = module.helper.set_additive
  project    = var.project
  dataset_id = module.helper.bindings_additive[each.key].name
  role       = module.helper.bindings_additive[each.key].role
  member     = module.helper.bindings_additive[each.key].member
}
