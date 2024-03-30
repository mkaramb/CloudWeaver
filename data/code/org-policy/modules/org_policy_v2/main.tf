
/******************************************
  Locals configuration for module logic
 *****************************************/
locals {
  organization = var.policy_root == "organization"
  folder       = var.policy_root == "folder"
  project      = var.policy_root == "project"
  # Making the policy roots as plural with additional 's' in the end - organizations, folders, projects
  policy_root = format("%s%s", var.policy_root, "s")

  boolean_policy = var.policy_type == "boolean"
  list_policy    = var.policy_type == "list"

  # Appends the rules variable with additional details
  # allow and deny list length
  # enforcement (true or false)
  # values with allow and deny list items
  rules = [
    for k, v in var.rules :
    merge(v, {
      allow_list_length = length(v.allow),
      deny_list_length  = length(v.deny),
      enforcement       = length(v.allow) > 0 || length(v.deny) > 0 ? null : v.enforcement,
      values            = [{ allow = v.allow, deny = v.deny }]
    })
  ]
}



/******************************************
  Organization policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "org_policy_boolean" {
  count = local.organization && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    dynamic "rules" {
      for_each = local.rules
      content {
        enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
      }
    }
  }
}

/******************************************
  Folder policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "folder_policy_boolean" {
  count = local.folder && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    dynamic "rules" {
      for_each = local.rules
      content {
        enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
      }
    }
  }
}

/******************************************
  Project policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "project_policy_boolean" {
  count = local.project && local.boolean_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    dynamic "rules" {
      for_each = local.rules
      content {
        enforce = rules.value.enforcement != false ? "TRUE" : "FALSE"
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
      }
    }
  }
}

/******************************************
  Exclude folders from policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "policy_boolean_exclude_folders" {
  for_each = (local.boolean_policy && !local.project) ? var.exclude_folders : []

  name   = "folders/${each.value}/policies/${var.constraint}"
  parent = "folders/${each.value}"

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}
/******************************************
  Exclude projects from policy (boolean constraint)
 *****************************************/
resource "google_org_policy_policy" "policy_boolean_exclude_projects" {
  for_each = (local.boolean_policy && !local.project) ? var.exclude_projects : []

  name   = "projects/${each.value}/policies/${var.constraint}"
  parent = "projects/${each.value}"

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}



/******************************************
  Organization policy, allow all, deny all, allow values and deny values (list constraint)
 *****************************************/
resource "google_org_policy_policy" "organization_policy" {
  count = local.organization && local.list_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    inherit_from_parent = var.inherit_from_parent
    dynamic "rules" {
      for_each = local.rules
      content {
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
        allow_all = rules.value.enforcement == false ? "TRUE" : null
        deny_all  = rules.value.enforcement == true ? "TRUE" : null
        dynamic "values" {
          for_each = rules.value.allow_list_length > 0 || rules.value.deny_list_length > 0 ? rules.value.values : []
          content {
            allowed_values = rules.value.allow_list_length > 0 && rules.value.deny_list_length == 0 ? values.value.allow : null
            denied_values  = rules.value.deny_list_length > 0 && rules.value.allow_list_length == 0 ? values.value.deny : null
          }
        }
      }
    }
  }
}

/******************************************
  Folder policy, allow all, deny all, allow values and deny values (list constraint)
 *****************************************/
resource "google_org_policy_policy" "folder_policy" {
  count = local.folder && local.list_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    inherit_from_parent = var.inherit_from_parent
    dynamic "rules" {
      for_each = local.rules
      content {
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
        allow_all = rules.value.enforcement == false ? "TRUE" : null
        deny_all  = rules.value.enforcement == true ? "TRUE" : null
        dynamic "values" {
          for_each = rules.value.allow_list_length > 0 || rules.value.deny_list_length > 0 ? rules.value.values : []
          content {
            allowed_values = rules.value.allow_list_length > 0 && rules.value.deny_list_length == 0 ? values.value.allow : null
            denied_values  = rules.value.deny_list_length > 0 && rules.value.allow_list_length == 0 ? values.value.deny : null
          }
        }
      }
    }
  }
}

/******************************************
  Project policy, allow all, deny all, allow values and deny values (list constraint)
 *****************************************/
resource "google_org_policy_policy" "project_policy" {
  count = local.project && local.list_policy ? 1 : 0

  name   = "${local.policy_root}/${var.policy_root_id}/policies/${var.constraint}"
  parent = "${local.policy_root}/${var.policy_root_id}"

  spec {
    inherit_from_parent = var.inherit_from_parent
    dynamic "rules" {
      for_each = local.rules
      content {
        dynamic "condition" {
          for_each = { for k, v in rules.value.conditions : k => v if length(rules.value.conditions) > 0 }
          content {
            description = condition.value.description
            expression  = condition.value.expression
            location    = condition.value.location
            title       = condition.value.title
          }
        }
        allow_all = rules.value.enforcement == false ? "TRUE" : null
        deny_all  = rules.value.enforcement == true ? "TRUE" : null
        dynamic "values" {
          for_each = rules.value.allow_list_length > 0 || rules.value.deny_list_length > 0 ? rules.value.values : []
          content {
            allowed_values = rules.value.allow_list_length > 0 && rules.value.deny_list_length == 0 ? values.value.allow : null
            denied_values  = rules.value.deny_list_length > 0 && rules.value.allow_list_length == 0 ? values.value.deny : null
          }
        }
      }
    }
  }
}

/******************************************
  Exclude folders from policy (list constraint)
 *****************************************/
resource "google_org_policy_policy" "folder_policy_list_exclude_folders" {
  for_each = (local.list_policy && !local.project) ? var.exclude_folders : []

  name   = "folders/${each.value}/policies/${var.constraint}"
  parent = "folders/${each.value}"


  spec {
    reset = true
  }
}

/******************************************
  Exclude projects from policy (list constraint)
 *****************************************/
resource "google_org_policy_policy" "project_policy_list_exclude_projects" {
  for_each = (local.list_policy && !local.project) ? var.exclude_projects : []

  name   = "projects/${each.value}/policies/${var.constraint}"
  parent = "projects/${each.value}"

  spec {
    reset = true
  }
}
