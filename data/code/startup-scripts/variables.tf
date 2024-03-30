variable "enable_init_gsutil_crcmod_el" {
  description = "If not false, include stdlib::init_gsutil_crcmod_el() prior to executing startup-script-custom.  Call this function from startup-script-custom to initialize gsutil as per https://cloud.google.com/storage/docs/gsutil/addlhelp/CRC32CandInstallingcrcmod#centos-rhel-and-fedora Intended for CentOS, RHEL and Fedora systems."
  type        = bool
  default     = false
}

variable "enable_get_from_bucket" {
  description = "If not false, include stdlib::get_from_bucket() prior to executing startup-script-custom.  Requires gsutil in the PATH.  See also enable_init_gsutil_crcmod_el feature flag."
  type        = bool
  default     = false
}

variable "enable_setup_init_script" {
  description = "If not false, include stdlib::setup_init_script() prior to executing startup-script-custom.   Call this function to load an init script from GCS into /etc/init.d and initialize it with chkconfig. This function depends on stdlib::get_from_bucket, so this function won't be enabled if enable_get_from_bucket is false."
  type        = bool
  default     = false
}

variable "enable_setup_sudoers" {
  description = "If true, include stdlib::setup_sudoers() prior to executing startup-script-custom. Call this function from startup-script-custom to setup unix usernames in sudoers Comma separated values must be posted to the project metadata key project/attributes/sudoers"
  type        = bool
  default     = false
}

