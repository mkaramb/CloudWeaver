
output "function_event_trigger" {
  description = "The information used to trigger the function when a log entry is exported to the topic."
  value = {
    "event_type" = "google.pubsub.topic.publish"
    "resource"   = google_pubsub_topic.main.name
  }
}
