
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "repository_url" {
  description = "The URI of the repo where the Terraform configs are stored."
  type        = string
}

variable "im_gitlab_pat" {
  description = "GitLab personal access token."
  type        = string
  sensitive   = true
}
