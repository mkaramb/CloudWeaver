
/******************************************
  Module kms_key_ring_iam_binding calling
 *****************************************/
module "kms_key_ring_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/kms_key_rings_iam"
  version = "~> 7.0"

  kms_key_rings = [var.kms_key_ring_one, var.kms_key_ring_two]
  mode          = "additive"

  bindings = {
    "roles/cloudkms.cryptoKeyEncrypter" = [
      "user:${var.user_email}",
      "group:${var.group_email}",
    ]
    "roles/cloudkms.cryptoKeyDecrypter" = [
      "user:${var.user_email}",
      "group:${var.group_email}",
    ]
  }
}
