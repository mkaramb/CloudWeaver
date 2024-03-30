
/******************************************
  Module pubsub_topic_iam_binding calling
 *****************************************/
module "pubsub_topic_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/pubsub_topics_iam"
  version = "~> 7.0"

  project       = var.pubsub_topic_project
  pubsub_topics = [var.pubsub_topic_one, var.pubsub_topic_two]
  mode          = "authoritative"

  bindings = {
    "roles/pubsub.publisher" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/pubsub.viewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
