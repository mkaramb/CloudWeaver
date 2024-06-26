# [START trafficdirector_url_map_header_based_routing]
resource "google_compute_url_map" "urlmap" {
  name            = "urlmap"
  description     = "header-based routing example"
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    route_rules {
      priority = 1
      service  = google_compute_backend_service.service_a.id
      match_rules {
        prefix_match = "/"
        ignore_case  = true
        header_matches {
          header_name = "abtest"
          exact_match = "a"
        }
      }
    }
    route_rules {
      priority = 2
      service  = google_compute_backend_service.service_b.id
      match_rules {
        ignore_case  = true
        prefix_match = "/"
        header_matches {
          header_name = "abtest"
          exact_match = "b"
        }
      }
    }
  }
}

resource "google_compute_backend_service" "default" {
  name        = "default"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_backend_service" "service_a" {
  name        = "service-a"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_backend_service" "service_b" {
  name        = "service-b"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
# [END trafficdirector_url_map_header_based_routing]
