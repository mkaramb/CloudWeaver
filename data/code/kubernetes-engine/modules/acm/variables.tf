
variable "cluster_name" {
  description = "GCP cluster Name used to reach cluster and which becomes the cluster name in the Config Sync kubernetes custom resource."
  type        = string
}

variable "project_id" {
  description = "GCP project_id used to reach cluster."
  type        = string
}

variable "location" {
  description = "GCP location used to reach cluster."
  type        = string
}

variable "enable_fleet_feature" {
  description = "Whether to enable the ACM feature on the fleet."
  type        = bool
  default     = true
}

variable "enable_fleet_registration" {
  description = "Whether to create a new membership."
  type        = bool
  default     = true
}

variable "cluster_membership_id" {
  description = "The cluster membership ID. If unset, one will be autogenerated."
  type        = string
  default     = ""
}

variable "configmanagement_version" {
  description = "Version of ACM."
  type        = string
  default     = ""
}

# Config Sync variables
variable "sync_repo" {
  description = "ACM Git repo address"
  type        = string
  default     = ""
}

variable "sync_branch" {
  description = "ACM repo Git branch. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "sync_revision" {
  description = "ACM repo Git revision. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

variable "source_format" {
  description = "Configures a non-hierarchical repo if set to 'unstructured'. Uses [ACM defaults](https://cloud.google.com/anthos-config-management/docs/how-to/installing#configuring-config-management-operator) when unset."
  type        = string
  default     = ""
}

variable "policy_dir" {
  description = "Subfolder containing configs in ACM Git repo. If un-set, uses Config Management default."
  type        = string
  default     = ""
}

# Config Sync Auth config
variable "secret_type" {
  description = "git authentication secret type, is passed through to ConfigManagement spec.git.secretType. Overriden to value 'ssh' if `create_ssh_key` is true"
  type        = string
  default     = "ssh"
}

variable "https_proxy" {
  description = "URL for the HTTPS proxy to be used when communicating with the Git repo."
  type        = string
  default     = null
}

variable "create_ssh_key" {
  description = "Controls whether a key will be generated for Git authentication"
  type        = bool
  default     = true
}

variable "ssh_auth_key" {
  description = "Key for Git authentication. Overrides 'create_ssh_key' variable. Can be set using 'file(path/to/file)'-function."
  type        = string
  default     = null
}

variable "gcp_service_account_email" {
  description = "The service account email for authentication when `secret_type` is `gcpServiceAccount`."
  type        = string
  default     = null
}

variable "enable_config_sync" {
  description = "Whether to enable the ACM Config Sync on the cluster"
  type        = bool
  default     = true
}

# Policy Controller config
variable "enable_policy_controller" {
  description = "Whether to enable the ACM Policy Controller on the cluster"
  type        = bool
  default     = true
}

variable "install_template_library" {
  description = "Whether to install the default Policy Controller template library"
  type        = bool
  default     = true
}

variable "enable_log_denies" {
  description = "Whether to enable logging of all denies and dryrun failures for ACM Policy Controller."
  type        = bool
  default     = false
}

variable "enable_mutation" {
  description = "Whether to enable mutations for ACM Policy Controller."
  type        = bool
  default     = false
}

# Hierarchy Controller config
variable "hierarchy_controller" {
  description = "Configurations for Hierarchy Controller. See [Hierarchy Controller docs](https://cloud.google.com/anthos-config-management/docs/how-to/installing-hierarchy-controller) for more details"
  type        = map(any)
  default     = null
}

variable "enable_referential_rules" {
  description = "Enables referential constraints which reference another object in it definition and are therefore eventually consistent."
  type        = bool
  default     = true
}

variable "policy_bundles" {
  description = "A list of Policy Controller policy bundles git urls (example: https://github.com/GoogleCloudPlatform/acm-policy-controller-library.git/bundles/policy-essentials-v2022) to install on the cluster."
  type        = list(string)
  default     = []
}

variable "create_metrics_gcp_sa" {
  description = "Create a Google service account for ACM metrics writing"
  type        = bool
  default     = false
}

variable "metrics_gcp_sa_name" {
  description = "The name of the Google service account for ACM metrics writing"
  type        = string
  default     = "acm-metrics-writer"
}
