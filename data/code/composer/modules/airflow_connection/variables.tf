
variable "project_id" {
  type        = string
  description = "Project ID where Cloud Composer Environment is created."
}

variable "region" {
  type        = string
  description = "Region where the Cloud Composer Environment is created."
}

variable "composer_env_name" {
  type        = string
  description = "Name of the Cloud Composer Environment."
}

variable "id" {
  type        = string
  description = "The ID of the connection within Airflow"
}

variable "host" {
  type        = string
  default     = null
  description = "The optional host field of the connection"
}

variable "uri" {
  type        = string
  default     = null
  sensitive   = true
  description = "The optional uri field of the connection"
}

variable "login" {
  type        = string
  default     = null
  sensitive   = true
  description = "The optional login field of the connection"
}

variable "password" {
  type        = string
  default     = null
  sensitive   = true
  description = "The optional password field of the connection"
}

variable "port" {
  type        = string
  default     = null
  description = "The optional port field of the connection"
}

variable "schema" {
  type        = string
  default     = null
  description = "The optional schema field of the connection"
}

variable "type" {
  type        = string
  default     = null
  description = "The optional type field of the connection"
}

variable "extra" {
  type        = any
  description = "The optional exta field of the connection. If this is not a string it will be encoded as json which is useful for things like oauth tokens and gcpcloudsql"
  default     = null
  sensitive   = true
}
