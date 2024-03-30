
data "google_client_config" "current" {
}

provider "cdap" {
  host  = "https://example-df-host.com/api/"
  token = data.google_client_config.current.access_token
}

module "connectors_streaming_1_0_0" {
  source  = "terraform-google-modules/data-fusion/google//modules/hub_artifact"
  version = "~> 3.0"

  bucket           = "aeba5c94-db31-451a-85ea-27047cbe133b" # Healthcare hub.
  package          = "healthcare-cloud-api-connectors"
  name             = "connectors-streaming"
  artifact_version = "1.0.0"
}
