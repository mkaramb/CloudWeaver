
/******************************************
  Locals configuration for module logic
 *****************************************/
locals {
  organization   = var.policy_for == "organization"
  folder         = var.policy_for == "folder"
  project        = var.policy_for == "project"
  boolean_policy = var.policy_type == "boolean"
  list_policy    = var.policy_type == "list" && !local.invalid_config

  // If allow/deny list empty and enforce is not set, enforce is set to true
  enforce               = var.allow_list_length > 0 || var.deny_list_length > 0 ? null : var.enforce != false
  invalid_config_case_1 = var.deny_list_length > 0 && var.allow_list_length > 0

  // We use var.enforce here because allow/deny lists can not be used together with enforce flag
  invalid_config_case_2 = var.allow_list_length + var.deny_list_length > 0 && var.enforce != null
  invalid_config        = var.policy_type == "list" && local.invalid_config_case_1 || local.invalid_config_case_2
}

/******************************************
  Checks a valid configuration for list constraint
 *****************************************/
resource "null_resource" "config_check" {
  /*
    This resource shows the user a message intentionally
    If user sets two (or more) of following variables when policy type is "list":
    - allow
    - deny
    - enforce ("true" or "false")
    the configuration is invalid and the message below is shown
  */
  count = local.invalid_config ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'For list constraints only one of enforce, allow, and deny may be included.'; false"
  }
}



/******************************************
  Organization policy (boolean constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_boolean" {
  count = local.organization && local.boolean_policy ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Folder policy (boolean constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_boolean" {
  count = local.folder && local.boolean_policy ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Project policy (boolean constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_boolean" {
  count = local.project && local.boolean_policy ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce != false
  }
}

/******************************************
  Exclude folders from policy (boolean constraint)
 *****************************************/
resource "google_folder_organization_policy" "policy_boolean_exclude_folders" {
  for_each = (local.boolean_policy && !local.project) ? var.exclude_folders : []

  folder     = each.value
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce == false
  }
}

/******************************************
  Exclude projects from policy (boolean constraint)
 *****************************************/
resource "google_project_organization_policy" "policy_boolean_exclude_projects" {
  for_each = (local.boolean_policy && !local.project) ? var.exclude_projects : []

  project    = each.value
  constraint = var.constraint

  boolean_policy {
    enforced = var.enforce == false
  }
}



/******************************************
  Organization policy, allow all (list constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_list_allow_all" {
  count = local.organization && local.list_policy && local.enforce == false ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  list_policy {
    allow {
      all = true
    }
  }
}

/******************************************
  Folder policy, allow all (list constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_list_allow_all" {
  count = local.folder && local.list_policy && local.enforce == false ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  list_policy {
    allow {
      all = true
    }
  }
}

/******************************************
  Project policy, allow all (list constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_list_allow_all" {
  count = local.project && local.list_policy && local.enforce == false ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  list_policy {
    allow {
      all = true
    }
  }
}

/******************************************
  Organization policy, deny all (list constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_list_deny_all" {
  count = local.organization && local.list_policy && local.enforce == true ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  list_policy {
    deny {
      all = true
    }
  }
}

/******************************************
  Folder policy, deny all (list constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_list_deny_all" {
  count = local.folder && local.list_policy && local.enforce == true ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  list_policy {
    deny {
      all = true
    }
  }
}

/******************************************
  Project policy, deny all (list constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_list_deny_all" {
  count = local.project && local.list_policy && local.enforce == true ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  list_policy {
    deny {
      all = true
    }
  }
}

/******************************************
  Organization policy, deny values (list constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_list_deny_values" {
  count = local.organization && local.list_policy && var.deny_list_length > 0 ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  list_policy {
    deny {
      values = var.deny
    }
  }
}

/******************************************
  Folder policy, deny values (list constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_list_deny_values" {
  count = local.folder && local.list_policy && var.deny_list_length > 0 ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  list_policy {
    deny {
      values = var.deny
    }
  }
}

/******************************************
  Project policy, deny values (list constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_list_deny_values" {
  count = local.project && local.list_policy && var.deny_list_length > 0 ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  list_policy {
    deny {
      values = var.deny
    }
  }
}

/******************************************
  Organization policy, allow values (list constraint)
 *****************************************/
resource "google_organization_policy" "org_policy_list_allow_values" {
  count = local.organization && local.list_policy && var.allow_list_length > 0 ? 1 : 0

  org_id     = var.organization_id
  constraint = var.constraint

  list_policy {
    allow {
      values = var.allow
    }
  }
}

/******************************************
  Folder policy, allow values (list constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_list_allow_values" {
  count = local.folder && local.list_policy && var.allow_list_length > 0 ? 1 : 0

  folder     = var.folder_id
  constraint = var.constraint

  list_policy {
    allow {
      values = var.allow
    }
  }
}

/******************************************
  Project policy, allow values (list constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_list_allow_values" {
  count = local.project && local.list_policy && var.allow_list_length > 0 ? 1 : 0

  project    = var.project_id
  constraint = var.constraint

  list_policy {
    allow {
      values = var.allow
    }
  }
}

/******************************************
  Exclude folders from policy (list constraint)
 *****************************************/
resource "google_folder_organization_policy" "folder_policy_list_exclude_folders" {
  for_each = (local.list_policy && !local.project) ? var.exclude_folders : []

  folder     = each.value
  constraint = var.constraint

  restore_policy {
    default = true
  }
}

/******************************************
  Exclude projects from policy (list constraint)
 *****************************************/
resource "google_project_organization_policy" "project_policy_list_exclude_projects" {
  for_each = (local.list_policy && !local.project) ? var.exclude_projects : []

  project    = each.value
  constraint = var.constraint

  restore_policy {
    default = true
  }
}
