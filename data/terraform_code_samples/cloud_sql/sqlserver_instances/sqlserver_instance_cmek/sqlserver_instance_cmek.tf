# [START cloud_sql_instance_service_identity]
resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}
# [END cloud_sql_instance_service_identity]

# [START cloud_sql_instance_keyring]
resource "google_kms_key_ring" "keyring" {
  provider = google-beta
  name     = "keyring-name"
  location = "us-central1"
}
# [END cloud_sql_instance_keyring]

# [START cloud_sql_instance_key]
resource "google_kms_crypto_key" "key" {
  provider = google-beta
  name     = "crypto-key-name"
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ENCRYPT_DECRYPT"
}
# [END cloud_sql_instance_key]

# [START cloud_sql_instance_crypto_key]
resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}
# [END cloud_sql_instance_crypto_key]

# [START cloud_sql_sqlserver_instance_cmek]
resource "google_sql_database_instance" "default" {
  name                = "sqlserver-instance-cmek"
  provider            = google-beta
  region              = "us-central1"
  database_version    = "SQLSERVER_2019_STANDARD"
  root_password       = "INSERT-PASSWORD-HERE "
  encryption_key_name = google_kms_crypto_key.key.id
  settings {
    tier = "db-custom-2-7680"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_cmek]
