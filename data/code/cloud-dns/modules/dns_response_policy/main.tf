
/**
Cloud DNS private zones let you create a single response policy per network that
modifies resolver behavior according to the policy created.
*/
resource "google_dns_response_policy" "this" {
  project              = var.project_id
  response_policy_name = var.policy_name
  description          = var.description
  dynamic "networks" {
    for_each = var.network_self_links
    content {
      network_url = networks.value
    }
  }
}

/**
Response policy rules can be created under a response policy to alter results for
selected query names or trigger passthru behavior that bypasses the response policy.
*/
resource "google_dns_response_policy_rule" "this" {
  for_each        = toset(keys(var.rules))
  provider        = google-beta
  project         = var.project_id
  rule_name       = each.key
  dns_name        = lookup(var.rules[each.key], "dns_name")
  response_policy = google_dns_response_policy.this.response_policy_name
  behavior        = lookup(var.rules[each.key], "rule_behavior", null)

  dynamic "local_data" {
    for_each = lookup(var.rules[each.key], "rule_behavior", "") == "bypassResponsePolicy" ? [] : [1]
    content {
      dynamic "local_datas" {
        for_each = lookup(var.rules[each.key], "rule_local_datas")
        content {
          name    = lookup(var.rules[each.key], "dns_name")
          rrdatas = local_datas.value.rrdatas
          ttl     = local_datas.value.ttl
          type    = local_datas.key # Only one local data allowed for each type.
        }
      }
    }
  }
}



variable "project_id" {
  type        = string
  description = "The ID of the project in which the DNS response policy needs to be created."
}

variable "description" {
  type        = string
  description = "The description of the response policy."
}

variable "network_self_links" {
  type        = list(string)
  description = "The self links of the network to which the dns response policy needs to be applied. Note that only one response policy can be applied on a network."
  default     = []
}

variable "rules" {
  type = map(object({
    dns_name      = string
    rule_behavior = optional(string)
    rule_local_datas = optional(map(object({
      ttl     = string
      rrdatas = list(string)
    })))
  }))
  description = <<EOF
  A Response Policy Rule is a selector that applies its behavior to queries that match the selector.
  Selectors are DNS names, which may be wildcards or exact matches.
  Takes a map as input where the key is the name of the rule. The map contains following attributes:
  Key - Name of the rule
  Value - Object of following attributes:
    * dns_name - DNS name where policy will be applied.
    * rule_behavior - Whether to override or passthru. Use value bypassResponsePolicy for passthru rules and skip this key for overriding rules.
    * rule_local_datas - When the rule behavior is override, policy will answer this matched DNS name directly with this DNS data. These resource record sets override any other DNS behavior for the matched name.
      * Each local datas object can contain following attributes:
        Key - One of the valid DNS resource type.
        Value - Object of following attributes:
           - ttl -  Number of seconds that this ResourceRecordSet can be cached by resolvers.
           - rrdatas - As defined in RFC 1035 (section 5) and RFC 1034 (section 3.6.1)
  EOF
}

variable "policy_name" {
  type        = string
  description = "Name of the DNS response policy."
}
