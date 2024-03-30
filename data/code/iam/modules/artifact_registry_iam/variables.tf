
variable "repositories" {
  description = "Artifact registry repositories list to add the IAM policies/bindings"
  default     = []
  type        = list(string)
}

variable "location" {
  description = "Location of the provided artifact registry repositories"
  type        = string
}

variable "project" {
  description = "Project where the artifact registry repositories are placed"
  type        = string
}

variable "mode" {
  description = "Mode for adding the IAM policies/bindings, additive and authoritative"
  type        = string
  default     = "additive"
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}
