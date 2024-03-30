
variable "project_id" {
  type        = string
  description = "The project id to deploy Github Runner MIG"
}

variable "repo_owner" {
  type        = string
  description = "Owner of the organisation for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}
