
output "load-balancer-ip" {
  value = module.gce-lb-https.external_ip
}

output "load-balancer-ipv6" {
  value       = module.gce-lb-https.ipv6_enabled ? module.gce-lb-https.external_ipv6_address : "undefined"
  description = "The IPv6 address of the load-balancer, if enabled; else \"undefined\""
}
