
data "google_client_config" "current" {
}

provider "cdap" {
  host  = "https://example-df-host.com/api/"
  token = data.google_client_config.current.access_token
}

module "verbose_dataproc" {
  source  = "terraform-google-modules/data-fusion/google//modules/dataproc_profile"
  version = "~> 3.0"

  name  = var.profile_name
  label = var.profile_name
  extra_properties = {
    "dataproc:dataproc.logging.stackdriver.job.yarn.container.enable" = true
  }
}
