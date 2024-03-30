
variable "delete_contents_on_destroy" {
  description = "(Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present."
  type        = bool
  default     = null
}

variable "default_table_expiration_ms" {
  description = "Default TTL of tables using the dataset in MS."
  default     = null
}

variable "project_id" {
  description = "Project where the dataset and table are created."
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table."
  type        = map(string)
}

variable "kms_key" {
  description = "The KMS key to use to encrypt data by default"
  type        = string
  default     = null
}
