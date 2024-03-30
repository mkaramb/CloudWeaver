
/******************************************
  Module pubsub_subscription_iam_binding calling
 *****************************************/
module "storage_buckets_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "~> 7.0"

  storage_buckets = [var.storage_bucket_one, var.storage_bucket_two]
  mode            = "additive"

  bindings = {
    "roles/storage.legacyBucketReader" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/storage.legacyBucketWriter" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
