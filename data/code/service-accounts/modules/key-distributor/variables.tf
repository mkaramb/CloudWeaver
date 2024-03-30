
variable "org_id" {
  type        = string
  description = "Organization ID where the Cloud Function will have access to create Service Account keys."
  default     = ""
}

variable "folder_ids" {
  type        = list(any)
  description = "Folder IDs where the Cloud Function will have access to create Service Account keys."
  default     = []
}

variable "project_ids" {
  type        = list(any)
  description = "Project IDs where the Cloud Function will have access to create Service Account keys."
  default     = []
}

variable "project_id" {
  type        = string
  description = "Project Id for the Cloud Function. Also if folder_ids and project_ids are empty, the Cloud Function will be granted access to create keys in this project by default."
}

variable "region" {
  type        = string
  description = "The region where the Cloud Function will run"
  default     = "us-central1"
}

variable "function_name" {
  type        = string
  description = "Name of the Cloud Function"
  default     = "key-distributor"
}

variable "public_key_file" {
  type        = string
  description = "Path of the ascii armored gpg public key. Create by running `gpg --export --armor <key-id> > pubkey.asc`"
  default     = "pubkey.asc"
}

variable "function_members" {
  type        = list(string)
  description = "List of IAM members (users, groups, etc) with the invoker permission on the CLoud Function"
}
