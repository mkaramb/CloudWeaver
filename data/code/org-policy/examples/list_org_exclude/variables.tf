
variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
}

variable "shared_reservation_project_id" {
  description = "The ID of a project that are allowed to create and own shared reservations in the org"
  type        = string
}
