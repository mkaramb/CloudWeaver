
variable "project_id" {
  type        = string
  description = "The project id to deploy Github Runner MIG"
}

variable "image" {
  type        = string
  description = "The github runner image"
}

variable "repo_url" {
  type        = string
  description = "Repo URL for the Github Action"
}


variable "repo_name" {
  type        = string
  description = "Name of the repo for the Github Action"
}


variable "repo_owner" {
  type        = string
  description = "Owner of the repo for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}
