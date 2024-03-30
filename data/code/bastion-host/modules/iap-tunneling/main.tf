
resource "google_compute_firewall" "allow_from_iap_to_instances" {
  count   = var.create_firewall_rule ? 1 : 0
  project = var.host_project != "" ? var.host_project : var.project
  name    = var.fw_name_allow_ssh_from_iap
  network = var.network

  allow {
    protocol = "tcp"
    ports    = toset(concat(["22"], var.additional_ports))
  }

  # https://cloud.google.com/iap/docs/using-tcp-forwarding#before_you_begin
  # This is the netblock needed to forward to the instances
  source_ranges = ["35.235.240.0/20"]

  target_service_accounts = length(var.service_accounts) > 0 ? var.service_accounts : null
  target_tags             = length(var.network_tags) > 0 ? var.network_tags : null
}

resource "google_iap_tunnel_instance_iam_binding" "enable_iap" {
  for_each = {
    for i in var.instances :
    "${i.name} ${i.zone}" => i
  }
  project  = var.project
  zone     = each.value.zone
  instance = each.value.name
  role     = "roles/iap.tunnelResourceAccessor"
  members  = var.members
}
