
locals {
  # Remove ".git" suffix if it's included
  url = trimsuffix(var.im_deployment_repo_uri, ".git")

  repo           = local.is_gh_repo ? local.gh_name : local.gl_project
  default_prefix = local.repo

  host_connection_name = var.host_connection_name != "" ? var.host_connection_name : "im-${random_id.resources_random_id.dec}-${var.project_id}-${var.deployment_id}"
  repo_connection_name = var.repo_connection_name != "" ? var.repo_connection_name : "im-${random_id.resources_random_id.dec}-${local.repo}"
}

data "google_project" "project" {
  project_id = var.project_id
}

// Added to various IDs to prevent potential conflicts for deployments targeting the same repository.
resource "random_id" "resources_random_id" {
  byte_length = 4
}

// Create the VCS connection.
resource "google_cloudbuildv2_connection" "vcs_connection" {
  project  = var.project_id
  location = var.location

  name = local.host_connection_name

  dynamic "github_config" {
    for_each = local.is_gh_repo ? [1] : []
    content {
      app_installation_id = var.github_app_installation_id
      authorizer_credential {
        oauth_token_secret_version = local.github_secret_version_id
      }
    }
  }

  dynamic "gitlab_config" {
    for_each = local.is_gl_repo ? [1] : []
    content {
      host_uri = var.gitlab_host_uri != "" ? var.gitlab_host_uri : null
      authorizer_credential {
        user_token_secret_version = local.gitlab_api_secret_version
      }
      read_authorizer_credential {
        user_token_secret_version = local.gitlab_read_api_secret_version
      }
      webhook_secret_secret_version = google_secret_manager_secret_version.gitlab_webhook_secret_version[0].name
    }
  }
}

// Create the repository connection.
resource "google_cloudbuildv2_repository" "repository_connection" {
  project           = var.project_id
  location          = var.location
  name              = local.repo_connection_name
  parent_connection = google_cloudbuildv2_connection.vcs_connection.name
  remote_uri        = var.im_deployment_repo_uri
}
