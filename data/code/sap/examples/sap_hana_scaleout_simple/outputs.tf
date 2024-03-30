output "sap_hana_primary_self_link" {
  description = "Self-link for the primary SAP HANA Scalout instance created."
  value       = module.hana_scaleout.sap_hana_primary_self_link
}

output "hana_scaleout_worker_self_links" {
  description = "List of self-links for the hana scaleout workers created"
  value       = module.hana_scaleout.hana_scaleout_worker_self_links
}

output "hana_scaleout_standby_self_links" {
  description = "List of self-links for the hana scaleout standby workers created"
  value       = module.hana_scaleout.hana_scaleout_standby_self_links
}
