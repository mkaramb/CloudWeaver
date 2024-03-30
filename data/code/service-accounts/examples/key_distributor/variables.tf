
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "public_key_file" {
  description = "ASCII armored PGP public key file"
  type        = string
}

variable "cfn_members" {
  description = "List of Cloud Function invokers in IAM member format(ex. `[\"user:me@example.com\"]`)."
  type        = list(string)
}
