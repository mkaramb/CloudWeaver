
variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
  default     = []
}

variable "project_id" {
  description = "Project ID where the bastion will run"
  type        = string
}

