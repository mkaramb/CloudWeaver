
variable "config" {
  description = "SLO configuration"
  type        = map(any)
}
#
# variable "project_id" {
#   description = ""
#   type        = string
# }
#
# variable "type" {
#   description = "Type of SLO"
#   type        = string
# }
#
# variable "method" {
#   description = "Method to compute SLO"
#   type        = string
# }
#
# variable "method_performance" {
#   description = "Method to compute SLO window performance"
#   default     = null
#   type        = string
# }
#
# variable "service" {
#   description = ""
#   type        = string
# }
#
# variable "slo_id" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "display_name" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "goal" {
#   description = ""
#   default     = null
#   type        = float
# }
#
# # Period
# variable "calendar_period" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "rolling_period_days" {
#   description = ""
#   default     = null
#   type        = integer
# }
#
# variable "window_period" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# # Ranges
# variable "range_min" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "range_max" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# # Cloud Platform APIs
# variable "api_method" {
#   description = ""
#   default     = null
# }
#
# variable "api_location" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "api_version" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "threshold" {
#   description = ""
#   default     = null
#   type        = string
# }
#
# variable "latency_threshold" {
#   description = "Latency threshold in ms"
#   default     = null
#   type        = string
# }
#
# # Filters
# variable "good_bad_metric_filter" {
#   description = "Filter for boolean metric (TRUE if good, FALSE if bad)"
#   default     = null
#   type        = string
# }
#
# variable "good_service_filter" {
#   description = "Filters for good / bad ratio"
#   default     = null
#   type        = string
# }
#
# variable "bad_service_filter" {
#   description = "Filters for good / bad ratio"
#   default     = null
#   type        = string
# }
#
# variable "total_service_filter" {
#   description = "Filters for good / bad ratio"
#   default     = null
#   type        = string
# }
#
# variable "metric_filter" {
#   description = "Metric filter"
#   default     = null
#   type        = string
# }
