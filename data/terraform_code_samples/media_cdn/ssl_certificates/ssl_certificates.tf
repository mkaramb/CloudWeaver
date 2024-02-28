# Media CDN Docs: https://cloud.google.com/media-cdn/docs/configure-ssl-certificates

# [START mediacdn_ssl_certificates_parent_tag]
# [START mediacdn_cert_mgr_dns_auth]
resource "google_certificate_manager_dns_authorization" "default" {
  name        = "example-dns-auth"
  description = "example dns authorization "
  domain      = "test.example.com"
}
# [END mediacdn_cert_mgr_dns_auth]

# [START mediacdn_cert_mgr_dns_cert]
resource "google_certificate_manager_certificate" "default" {
  name        = "example-dns-cert"
  description = "example dns certificate"
  scope       = "EDGE_CACHE"
  managed {
    domains = [
      google_certificate_manager_dns_authorization.default.domain,
    ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.default.id,
    ]
  }
}
# [END mediacdn_cert_mgr_dns_cert]
# [END mediacdn_ssl_certificates_parent_tag]
