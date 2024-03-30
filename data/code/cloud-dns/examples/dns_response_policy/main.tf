
module "dns_response_policy" {
  source  = "terraform-google-modules/cloud-dns/google//modules/dns_response_policy"
  version = "~> 5.0"

  project_id         = var.project_id
  policy_name        = "dns-response-policy-test"
  network_self_links = [google_compute_network.this.self_link]
  description        = "Example DNS response policy created by terraform module."
  rules = {
    "override-google-com" = {
      dns_name = "*.google.com."
      rule_local_datas = {
        "A" = { # Record type.
          rrdatas = ["192.0.2.91"]
          ttl     = 300
        },
        "AAAA" = {
          rrdatas = ["2001:db8::8bd:1002"]
          ttl     = 300
        }
      }
    },
    "override-withgoogle-com" = {
      dns_name = "withgoogle.com."
      rule_local_datas = {
        "A" = {
          rrdatas = ["193.0.2.93"]
          ttl     = 300
        }
      }
    },
    "bypass-google-account-domain" = {
      dns_name      = "account.google.com."
      rule_behavior = "bypassResponsePolicy"
    }
  }
}



resource "random_string" "suffix" {
  length  = 4
  upper   = "false"
  lower   = "true"
  numeric = "false"
  special = "false"
}

resource "google_compute_network" "this" {
  name                    = "cft-cloud-dns-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
  project                 = var.project_id
}



variable "project_id" {
  type        = string
  description = "The ID of the project in which the DNS response policy needs to be created."
}
