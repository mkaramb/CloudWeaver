
variable "policy_for" {
  description = "Resource hierarchy node to apply the policy to: can be one of `organization`, `folder`, or `project`."
  type        = string
}

variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "The folder id for putting the policy"
  type        = string
  default     = null
}

variable "project_id" {
  description = "The project id for putting the policy"
  type        = string
  default     = null
}

variable "vms_to_allow" {
  description = "The list of VMs are allowed to use external IP, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}

variable "exclude_folders" {
  description = "Set of folders to exclude from the policy"
  type        = set(string)
  default     = []
}

variable "exclude_projects" {
  description = "Set of projects to exclude from the policy"
  type        = set(string)
  default     = []
}
