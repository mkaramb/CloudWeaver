# Terraform Registry: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_services_edge_cache_service
# Google Cloud Documentation
#   1. https://cloud.google.com/media-cdn/docs/quickstart#create-service
#   2. https://cloud.google.com/media-cdn/docs/origins#cloud-storage-origins

# [START mediacdn_quickstart_parent_tag]
resource "random_id" "unique_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name                        = "my-bucket-${random_id.unique_suffix.hex}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

# [START mediacdn_edge_cache_origin]
resource "google_network_services_edge_cache_origin" "default" {
  name           = "cloud-storage-origin"
  origin_address = "gs://my-bucket-${random_id.unique_suffix.hex}"
}
# [END mediacdn_edge_cache_origin]

# [START mediacdn_edge_cache_service]
resource "google_network_services_edge_cache_service" "default" {
  name = "cloud-media-service"
  routing {
    host_rule {
      hosts        = ["googlecloudexample.com"]
      path_matcher = "routes"
    }
    path_matcher {
      name = "routes"
      route_rule {
        description = "a route rule to match against"
        priority    = 1
        match_rule {
          prefix_match = "/"
        }
        origin = google_network_services_edge_cache_origin.default.name
        route_action {
          cdn_policy {
            cache_mode  = "CACHE_ALL_STATIC"
            default_ttl = "3600s"
          }
        }
        header_action {
          response_header_to_add {
            header_name  = "x-cache-status"
            header_value = "{cdn_cache_status}"
          }
        }
      }
    }
  }
}
# [END mediacdn_edge_cache_service]
# [END mediacdn_quickstart_parent_tag]
