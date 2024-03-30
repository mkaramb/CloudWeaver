
/******************************************
  Module kms_crypto_key_iam_binding calling
 *****************************************/
module "kms_crypto_key_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/kms_crypto_keys_iam"
  version = "~> 7.0"

  kms_crypto_keys = [var.kms_crypto_key_one, var.kms_crypto_key_two]

  mode = "authoritative"

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
