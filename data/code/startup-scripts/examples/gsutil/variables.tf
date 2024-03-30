
variable "project_id" {
  description = "The project_id to deploy the example instance into.  (e.g. \"simple-sample-project-1234\")"
}

variable "region" {
  description = "The region to deploy to"
}

variable "network" {
  description = "The network name to deploy to"
  default     = "default"
}

variable "service_account_email" {
  description = "The service acocunt email to associate with the example instance.  Should have storage.buckets.get to use stdlib::get_from_bucket"
}

variable "message" {
  description = "The content to place in a bucket object message.txt. startup-script-custom fetches this object and validate this message against the content as an end-to-end example of stdlib::get_from_bucket()."
  default     = "Hello World! uuid=0afce28a-057b-42cf-a90f-493de3c0666b"
}

