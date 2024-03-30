

output "ca_cert_pem" {
  value     = tls_self_signed_cert.root.*.cert_pem
  sensitive = true

  description = "CA certificate used to verify Vault TLS client connections."

}

output "ca_key_pem" {
  value     = tls_private_key.root.*.private_key_pem
  sensitive = true

  description = "Private key for the CA."
}

output "vault_addr" {
  value       = "https://${local.lb_ip}:${var.vault_port}"
  description = "Full protocol, address, and port (FQDN) pointing to the Vault load balancer.This is a drop-in to VAULT_ADDR: `export VAULT_ADDR=\"$(terraform output vault_addr)\"`. And then continue to use Vault commands as usual."
}

output "vault_lb_addr" {
  value       = local.lb_ip
  description = "Address of the load balancer without port or protocol information. You probably want to use `vault_addr`."
}

output "vault_lb_port" {
  value       = var.vault_port
  description = "Port where Vault is exposed on the load balancer."
}
