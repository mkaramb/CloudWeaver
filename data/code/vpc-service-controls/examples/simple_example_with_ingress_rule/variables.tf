
variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
}

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}

variable "members" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}

variable "regions" {
  description = "The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = []
}

variable "perimeter_name" {
  description = "Perimeter name of the Access Policy.."
  type        = string
  default     = "regular_perimeter_1"
}

variable "access_level_name" {
  description = "Access level name of the Access Policy."
  type        = string
  default     = "terraform_members"
}

variable "read_bucket_identities" {
  description = "List of all identities should get read access on bucket"
  type        = list(string)
  default     = []
}

variable "buckets_prefix" {
  description = "Bucket Prefix"
  type        = string
  default     = "test-bucket"
}

variable "buckets_names" {
  description = "Buckets Names as list of strings"
  type        = list(string)
  default     = ["bucket1", "bucket2"]
}
