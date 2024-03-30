output "sap_hana_primary_self_link" {
  description = "SAP HANA self-link for the primary instance created"
  value       = module.sap_hana.sap_hana_primary_self_link
}

output "sap_hana_worker_self_links" {
  description = "SAP HANA self-links for the secondary instances created"
  value       = module.sap_hana.sap_hana_worker_self_links
}
