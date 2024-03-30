
data "google_client_config" "current" {}

provider "cdap" {
  host  = "https://example-df-host.com/api/"
  token = data.google_client_config.current.access_token
}

module "staging" {
  source  = "terraform-google-modules/data-fusion/google//modules/namespace"
  version = "~> 3.0"

  name = var.name
  preferences = {
    FOO = "BAR"
  }
}
