
module "uptime-check" {
  source  = "terraform-google-modules/cloud-operations/google//modules/simple-uptime-check"
  version = "~> 0.4"

  project_id                = var.project_id
  uptime_check_display_name = var.uptime_check_display_name
  protocol                  = "HTTPS"
  monitored_resource = {
    monitored_resource_type = "uptime_url"
    labels = {
      "project_id" = var.project_id
      "host"       = var.hostname
    }
  }

  notification_channels = [
    {
      display_name = "Email Notification Channel"
      type         = "email"
      labels       = { email_address = var.email }
    },
    # {
    #   display_name = "SMS Notification Channel"
    #   type         = "sms"
    #   labels       = { number = var.sms }
    # }
  ]
}
