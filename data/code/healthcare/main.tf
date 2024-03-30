
resource "google_healthcare_dataset" "dataset" {
  name      = var.name
  project   = var.project
  location  = var.location
  time_zone = var.time_zone
}

resource "google_healthcare_dicom_store" "dicom_stores" {
  provider = google-beta

  for_each = {
    for s in var.dicom_stores :
    s.name => s
  }

  name    = each.value.name
  dataset = google_healthcare_dataset.dataset.id
  labels  = lookup(each.value, "labels", null)

  dynamic "notification_config" {
    for_each = lookup(each.value, "notification_config", null) != null ? [each.value.notification_config] : []
    content {
      pubsub_topic = notification_config.value.pubsub_topic
    }
  }

  dynamic "stream_configs" {
    for_each = lookup(each.value, "stream_configs", [])

    content {
      bigquery_destination {
        table_uri = stream_configs.value.bigquery_destination.table_uri
      }
    }
  }
}

resource "google_healthcare_fhir_store" "fhir_stores" {
  provider = google-beta

  for_each = {
    for s in var.fhir_stores :
    s.name => s
  }

  name    = each.value.name
  dataset = google_healthcare_dataset.dataset.id
  version = each.value.version
  labels  = lookup(each.value, "labels", null)

  enable_update_create                = lookup(each.value, "enable_update_create", null)
  disable_referential_integrity       = lookup(each.value, "disable_referential_integrity", null)
  disable_resource_versioning         = lookup(each.value, "disable_resource_versioning", null)
  enable_history_import               = lookup(each.value, "enable_history_import", null)
  complex_data_type_reference_parsing = lookup(each.value, "complex_data_type_reference_parsing", null)

  dynamic "notification_config" {
    for_each = lookup(each.value, "notification_config", null) != null ? [each.value.notification_config] : []
    content {
      pubsub_topic = notification_config.value.pubsub_topic
    }
  }

  dynamic "notification_configs" {
    for_each = lookup(each.value, "notification_configs", [])
    content {
      pubsub_topic                     = lookup(notification_configs.value, "pubsub_topic", null)
      send_full_resource               = lookup(notification_configs.value, "send_full_resource", null)
      send_previous_resource_on_delete = lookup(notification_configs.value, "send_previous_resource_on_delete", null)
    }
  }

  dynamic "stream_configs" {
    for_each = lookup(each.value, "stream_configs", [])

    content {
      resource_types = lookup(stream_configs.value, "resource_types", null)

      bigquery_destination {
        dataset_uri = stream_configs.value.bigquery_destination.dataset_uri

        schema_config {
          schema_type               = lookup(stream_configs.value.bigquery_destination.schema_config, "schema_type", null)
          recursive_structure_depth = stream_configs.value.bigquery_destination.schema_config.recursive_structure_depth

          dynamic "last_updated_partition_config" {
            for_each = lookup(stream_configs.value.bigquery_destination.schema_config, "last_updated_partition_config", null) != null ? [stream_configs.value.bigquery_destination.schema_config.last_updated_partition_config] : []
            content {
              type          = last_updated_partition_config.value.type
              expiration_ms = lookup(last_updated_partition_config.value, "expiration_ms", null)
            }
          }
        }
      }
    }
  }
}

resource "google_healthcare_hl7_v2_store" "hl7_v2_stores" {
  provider = google-beta
  for_each = {
    for s in var.hl7_v2_stores :
    s.name => s
  }

  name    = each.value.name
  dataset = google_healthcare_dataset.dataset.id
  labels  = lookup(each.value, "labels", null)

  dynamic "notification_configs" {
    for_each = lookup(each.value, "notification_configs", [])
    content {
      pubsub_topic = notification_configs.value.pubsub_topic
    }
  }

  dynamic "parser_config" {
    for_each = lookup(each.value, "parser_config", null) != null ? [each.value.parser_config] : []
    content {
      allow_null_header  = lookup(parser_config.value, "allow_null_header", null)
      segment_terminator = lookup(parser_config.value, "segment_terminator", null)
      schema             = lookup(parser_config.value, "schema", null)
      version            = lookup(parser_config.value, "version", null)
    }
  }
}

resource "google_healthcare_consent_store" "consent_stores" {
  for_each = {
    for s in var.consent_stores :
    s.name => s
  }

  name                            = each.value.name
  dataset                         = google_healthcare_dataset.dataset.id
  labels                          = lookup(each.value, "labels", null)
  enable_consent_create_on_update = lookup(each.value, "enable_consent_create_on_update", null)
  default_consent_ttl             = lookup(each.value, "default_consent_ttl", null)
}



locals {
  all_dicom_iam_members = flatten([
    for s in var.dicom_stores : [
      for m in lookup(s, "iam_members", []) : {
        store_name = s.name
        role       = m.role
        member     = m.member
      }
    ]
  ])
  all_fhir_iam_members = flatten([
    for s in var.fhir_stores : [
      for m in lookup(s, "iam_members", []) : {
        store_name = s.name
        role       = m.role
        member     = m.member
      }
    ]
  ])
  all_hl7_v2_iam_members = flatten([
    for s in var.hl7_v2_stores : [
      for m in lookup(s, "iam_members", []) : {
        store_name = s.name
        role       = m.role
        member     = m.member
      }
    ]
  ])
  all_consent_iam_members = flatten([
    for s in var.consent_stores : [
      for m in lookup(s, "iam_members", []) : {
        store_name = s.name
        role       = m.role
        member     = m.member
      }
    ]
  ])
}

resource "google_healthcare_dataset_iam_member" "dataset_iam_members" {
  for_each = {
    for m in var.iam_members :
    "${m.role} ${m.member}" => m
  }
  dataset_id = google_healthcare_dataset.dataset.id
  role       = each.value.role
  member     = each.value.member
}

resource "google_healthcare_dicom_store_iam_member" "dicom_store_iam_members" {
  for_each = {
    for m in local.all_dicom_iam_members :
    "${m.store_name} ${m.role} ${m.member}" => m
  }
  dicom_store_id = google_healthcare_dicom_store.dicom_stores[each.value.store_name].id
  role           = each.value.role
  member         = each.value.member
}

resource "google_healthcare_fhir_store_iam_member" "fhir_store_iam_members" {
  for_each = {
    for m in local.all_fhir_iam_members :
    "${m.store_name} ${m.role} ${m.member}" => m
  }
  fhir_store_id = google_healthcare_fhir_store.fhir_stores[each.value.store_name].id
  role          = each.value.role
  member        = each.value.member
}

resource "google_healthcare_hl7_v2_store_iam_member" "hl7_v2_store_iam_members" {
  for_each = {
    for m in local.all_hl7_v2_iam_members :
    "${m.store_name} ${m.role} ${m.member}" => m
  }
  hl7_v2_store_id = google_healthcare_hl7_v2_store.hl7_v2_stores[each.value.store_name].id
  role            = each.value.role
  member          = each.value.member
}

resource "google_healthcare_consent_store_iam_member" "consent_store_iam_members" {
  for_each = {
    for m in local.all_consent_iam_members :
    "${m.store_name} ${m.role} ${m.member}" => m
  }
  consent_store_id = google_healthcare_consent_store.consent_stores[each.value.store_name].id
  dataset          = google_healthcare_consent_store.consent_stores[each.value.store_name].dataset
  role             = each.value.role
  member           = each.value.member
}
