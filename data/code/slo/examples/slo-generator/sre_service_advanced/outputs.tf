
output "slo-generator" {
  value = module.slo-generator
}

output "team1-slos" {
  value = module.team1-slos
}

output "team2-slos" {
  value = module.team2-slos
}

output "service_account_email" {
  value = google_service_account.service_account.email
}
