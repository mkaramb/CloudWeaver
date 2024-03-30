output "sap_hana_ha_primary_instance_self_link" {
  description = "Self-link for the primary SAP HANA HA instance created."
  value       = module.sap_hana_ha.sap_hana_ha_primary_instance_self_link
}
output "sap_hana_ha_secondary_instance_self_link" {
  description = "Self-link for the secondary SAP HANA HA instance created."
  value       = module.sap_hana_ha.sap_hana_ha_secondary_instance_self_link
}
output "sap_hana_ha_loadbalander_link" {
  description = "Link to the optional load balancer"
  value       = module.sap_hana_ha.sap_hana_ha_loadbalander_link
}
output "sap_hana_ha_firewall_link" {
  description = "Link to the optional fire wall"
  value       = module.sap_hana_ha.sap_hana_ha_firewall_link
}
