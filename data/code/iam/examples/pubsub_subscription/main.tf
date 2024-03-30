
/******************************************
  Module pubsub_subscription_iam_binding calling
 *****************************************/
module "pubsub_subscription_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/pubsub_subscriptions_iam"
  version = "~> 7.0"

  project              = var.pubsub_subscription_project
  pubsub_subscriptions = [var.pubsub_subscription_one, var.pubsub_subscription_two]
  mode                 = "additive"

  bindings = {
    "roles/pubsub.viewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/pubsub.editor" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
