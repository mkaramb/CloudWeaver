
/******************************************
  Run helper module to get generic calculated data
 *****************************************/
module "helper" {
  source   = "../helper"
  bindings = var.bindings
  mode     = var.mode
  entities = var.repositories
}

/******************************************
  Artifact registry repository IAM binding authoritative
 *****************************************/
resource "google_artifact_registry_repository_iam_binding" "artifact_registry_iam_authoritative" {
  for_each   = module.helper.set_authoritative
  provider   = google-beta # Needed resource currently in beta
  project    = var.project
  repository = module.helper.bindings_authoritative[each.key].name
  role       = module.helper.bindings_authoritative[each.key].role
  members    = module.helper.bindings_authoritative[each.key].members
  location   = var.location
}

/******************************************
  Artifact registry repository IAM binding additive
 *****************************************/

resource "google_artifact_registry_repository_iam_member" "artifact_registry_iam_additive" {
  for_each   = module.helper.set_additive
  provider   = google-beta # Needed resource currently in beta
  project    = var.project
  repository = module.helper.bindings_additive[each.key].name
  role       = module.helper.bindings_additive[each.key].role
  member     = module.helper.bindings_additive[each.key].member
  location   = var.location
}
