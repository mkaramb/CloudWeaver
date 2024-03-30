/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "14.4"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "aiplatform.googleapis.com",
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigquerystorage.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "compute.googleapis.com",
    "config.googleapis.com",
    "datacatalog.googleapis.com",
    "dataform.googleapis.com",
    "datalineage.googleapis.com",
    "notebooks.googleapis.com",
    "run.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com"
  ]

  activate_api_identities = [
    {
      api = "workflows.googleapis.com"
      roles = [
        "roles/workflows.viewer"
      ],
      api = "bigquerydatatransfer.googleapis.com"
      roles = [
        "roles/bigquerydatatransfer.serviceAgent"
      ]
    }
  ]
}

# Wait after APIs are enabled to give time for them to spin up
resource "time_sleep" "wait_after_apis" {
  create_duration = "30s"
  depends_on      = [module.project-services]
}

# resource "google_project_service_identity" "default" {
#   provider = google-beta
#   project = module.project-services.project_id
#   service = "workflows.googleapis.com"
# }

# Create random ID to be used for deployment uniqueness
resource "random_id" "id" {
  byte_length = 4
}

# Set up Storage Buckets
## Set up the raw storage bucket for data
resource "google_storage_bucket" "raw_bucket" {
  name                        = "ds-edw-raw-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  public_access_prevention = "enforced"

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}


/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Define the list of notebook files to be created
locals {
  notebook_names = [
    for s in fileset("${path.module}/templates/notebooks/", "*.ipynb") : trimsuffix(s, ".ipynb")
  ]
}

# Create the notebook files to be uploaded
resource "local_file" "notebooks" {
  count    = length(local.notebook_names)
  filename = "${path.module}/src/function/notebooks/${local.notebook_names[count.index]}.ipynb"
  content = templatefile("${path.module}/templates/notebooks/${local.notebook_names[count.index]}.ipynb", {
    PROJECT_ID     = format("\\%s${module.project-services.project_id}\\%s", "\"", "\""),
    REGION         = format("\\%s${var.region}\\%s", "\"", "\""),
    GCS_BUCKET_URI = google_storage_bucket.raw_bucket.url
    }
  )
}

# Upload the Cloud Function source code to a GCS bucket
## Define/create zip file for the Cloud Function source. This includes notebooks that will be uploaded
data "archive_file" "create_notebook_function_zip" {
  type        = "zip"
  output_path = "${path.module}/tmp/notebooks_function_source.zip"
  source_dir  = "${path.module}/src/function/"

  depends_on = [local_file.notebooks]
}

## Set up a storage bucket for Cloud Function source code
resource "google_storage_bucket" "function_source" {
  name                        = "ds-edw-gcf-source-${random_id.id.hex}"
  project                     = module.project-services.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  public_access_prevention = "enforced"

  depends_on = [time_sleep.wait_after_apis]

  labels = var.labels
}

## Upload the zip file of the source code to GCS
resource "google_storage_bucket_object" "function_source_upload" {
  name   = "notebooks_function_source.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.create_notebook_function_zip.output_path
}

# Manage Cloud Function permissions and access
## Create a service account to manage the function
resource "google_service_account" "cloud_function_manage_sa" {
  project                      = module.project-services.project_id
  account_id                   = "notebook-deployment"
  display_name                 = "Cloud Functions Service Account"
  description                  = "Service account used to manage Cloud Function"
  create_ignore_already_exists = var.create_ignore_service_accounts

  depends_on = [
    time_sleep.wait_after_apis,
  ]
}

## Define the IAM roles that are granted to the Cloud Function service account
locals {
  cloud_function_roles = [
    "roles/cloudfunctions.admin", // Service account role to manage access to the remote function
    "roles/dataform.admin",       // Edit access code resources
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/run.invoker",         // Service account role to invoke the remote function
    "roles/storage.objectViewer" // Read GCS files
  ]
}

## Assign required permissions to the function service account
resource "google_project_iam_member" "function_manage_roles" {
  project = module.project-services.project_id
  count   = length(local.cloud_function_roles)
  role    = local.cloud_function_roles[count.index]
  member  = "serviceAccount:${google_service_account.cloud_function_manage_sa.email}"

  depends_on = [google_service_account.cloud_function_manage_sa, google_project_iam_member.dts_roles]
}

## Grant the Cloud Workflows service account access to act as the Cloud Function service account
resource "google_service_account_iam_member" "workflow_auth_function" {
  service_account_id = google_service_account.cloud_function_manage_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.workflow_manage_sa.email}"

  depends_on = [
    google_service_account.workflow_manage_sa,
    google_project_iam_member.function_manage_roles
  ]
}

locals {
  dataform_region = (var.dataform_region == null ? var.region : var.dataform_region)
}

# Setup Dataform repositories to host notebooks
## Create the Dataform repos
resource "google_dataform_repository" "notebook_repo" {
  count        = length(local.notebook_names)
  provider     = google-beta
  project      = module.project-services.project_id
  region       = local.dataform_region
  name         = local.notebook_names[count.index]
  display_name = local.notebook_names[count.index]
  labels = {
    "data-warehouse"         = "true"
    "single-file-asset-type" = "notebook"
  }
  depends_on = [time_sleep.wait_after_apis]
}

## Grant Cloud Function service account access to write to the repo
resource "google_dataform_repository_iam_member" "function_manage_repo" {
  provider   = google-beta
  project    = module.project-services.project_id
  region     = local.dataform_region
  role       = "roles/dataform.admin"
  member     = "serviceAccount:${google_service_account.cloud_function_manage_sa.email}"
  count      = length(local.notebook_names)
  repository = local.notebook_names[count.index]
  depends_on = [time_sleep.wait_after_apis, google_service_account_iam_member.workflow_auth_function, google_dataform_repository.notebook_repo]
}

## Grant Cloud Workflows service account access to write to the repo
resource "google_dataform_repository_iam_member" "workflow_manage_repo" {
  provider   = google-beta
  project    = module.project-services.project_id
  region     = local.dataform_region
  role       = "roles/dataform.admin"
  member     = "serviceAccount:${google_service_account.workflow_manage_sa.email}"
  count      = length(local.notebook_names)
  repository = local.notebook_names[count.index]

  depends_on = [
    google_project_iam_member.workflow_manage_sa_roles,
    google_service_account_iam_member.workflow_auth_function,
    google_dataform_repository_iam_member.function_manage_repo,
    google_dataform_repository.notebook_repo
  ]
}

# Create and deploy a Cloud Function to deploy notebooks
## Create the Cloud Function
resource "google_cloudfunctions2_function" "notebook_deploy_function" {
  name        = "deploy-notebooks"
  project     = module.project-services.project_id
  location    = var.region
  description = "A Cloud Function that deploys sample notebooks."
  build_config {
    runtime     = "python310"
    entry_point = "run_it"

    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_source_upload.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    # min_instance_count can be set to 1 to improve performance and responsiveness
    min_instance_count               = 0
    available_memory                 = "512Mi"
    timeout_seconds                  = 300
    max_instance_request_concurrency = 1
    available_cpu                    = "2"
    ingress_settings                 = "ALLOW_ALL"
    all_traffic_on_latest_revision   = true
    service_account_email            = google_service_account.cloud_function_manage_sa.email
    environment_variables = {
      "PROJECT_ID" : module.project-services.project_id,
      "REGION" : local.dataform_region
    }
  }

  depends_on = [
    time_sleep.wait_after_apis,
    google_project_iam_member.function_manage_roles,
    google_dataform_repository.notebook_repo,
    google_dataform_repository_iam_member.workflow_manage_repo,
    google_dataform_repository_iam_member.function_manage_repo
  ]
}

## Wait for Function deployment to complete
resource "time_sleep" "wait_after_function" {
  create_duration = "5s"
  depends_on      = [google_cloudfunctions2_function.notebook_deploy_function]
}



# Set up the Workflow
## Create the Workflows service account
resource "google_service_account" "workflow_manage_sa" {
  project                      = module.project-services.project_id
  account_id                   = "cloud-workflow-sa-${random_id.id.hex}"
  display_name                 = "Service Account for Cloud Workflows"
  description                  = "Service account used to manage Cloud Workflows"
  create_ignore_already_exists = var.create_ignore_service_accounts


  depends_on = [time_sleep.wait_after_apis]
}

## Define the IAM roles granted to the Workflows service account
locals {
  workflow_roles = [
    "roles/bigquery.connectionUser",
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
    "roles/run.invoker",
    "roles/storage.objectAdmin",
    "roles/workflows.admin",
  ]
}

## Grant the Workflow service account access
resource "google_project_iam_member" "workflow_manage_sa_roles" {
  count   = length(local.workflow_roles)
  project = module.project-services.project_id
  member  = "serviceAccount:${google_service_account.workflow_manage_sa.email}"
  role    = local.workflow_roles[count.index]

  depends_on = [google_service_account.workflow_manage_sa]
}

## Create the workflow
resource "google_workflows_workflow" "workflow" {
  name            = "initial-workflow"
  project         = module.project-services.project_id
  region          = var.region
  description     = "Runs post Terraform setup steps for Solution in Console"
  service_account = google_service_account.workflow_manage_sa.id

  source_contents = templatefile("${path.module}/templates/workflow.tftpl", {
    raw_bucket    = google_storage_bucket.raw_bucket.name,
    dataset_id    = google_bigquery_dataset.ds_edw.dataset_id,
    function_url  = google_cloudfunctions2_function.notebook_deploy_function.url
    function_name = google_cloudfunctions2_function.notebook_deploy_function.name
  })

  labels = var.labels

  depends_on = [
    google_project_iam_member.workflow_manage_sa_roles,
    time_sleep.wait_after_function
  ]
}

module "workflow_polling_1" {
  source               = "./workflow_polling"
  workflow_id          = google_workflows_workflow.workflow.id
  input_workflow_state = null

  depends_on = [
    google_storage_bucket.raw_bucket,
    google_bigquery_routine.sp_bigqueryml_generate_create,
    google_bigquery_routine.sp_bigqueryml_model,
    google_bigquery_routine.sproc_sp_demo_lookerstudio_report,
    google_bigquery_routine.sp_provision_lookup_tables,
    google_workflows_workflow.workflow,
    google_storage_bucket.raw_bucket,
    google_cloudfunctions2_function.notebook_deploy_function,
    time_sleep.wait_after_function,
    google_service_account_iam_member.workflow_auth_function
  ]
}


module "workflow_polling_4" {
  source               = "./workflow_polling"
  workflow_id          = google_workflows_workflow.workflow.id
  input_workflow_state = module.workflow_polling_1.workflow_state

  depends_on = [
    module.workflow_polling_1
  ]
}

# TODO: Expand testing to support more dynamic polling of workflow state
# module "workflow_polling_1" {
#   source = "./workflow_polling"

#   workflow_id          = google_workflows_workflow.workflow.id
#   input_workflow_state = null

#   depends_on = [
#     google_storage_bucket.raw_bucket,
#     google_bigquery_routine.sp_bigqueryml_generate_create,
#     google_bigquery_routine.sp_bigqueryml_model,
#     google_bigquery_routine.sproc_sp_demo_lookerstudio_report,
#     google_bigquery_routine.sp_provision_lookup_tables,
#     google_workflows_workflow.workflow,
#     google_storage_bucket.raw_bucket,
#     google_cloudfunctions2_function.notebook_deploy_function,
#     time_sleep.wait_after_function,
#     google_service_account_iam_member.workflow_auth_function
#   ]
# }

# module "workflow_polling_2" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_1.workflow_state

#   depends_on = [
#     module.workflow_polling_1
#   ]
# }

# module "workflow_polling_3" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_2.workflow_state

#   depends_on = [
#     module.workflow_polling_2
#   ]
# }

# module "workflow_polling_4" {
#   source      = "./workflow_polling"
#   workflow_id = google_workflows_workflow.workflow.id

#   input_workflow_state = module.workflow_polling_3.workflow_state

#   depends_on = [
#     module.workflow_polling_3
#   ]
# }



# Set up BigQuery resources
## Create the BigQuery dataset
resource "google_bigquery_dataset" "ds_edw" {
  project                    = module.project-services.project_id
  dataset_id                 = "thelook"
  friendly_name              = "My EDW Dataset"
  description                = "My EDW Dataset with tables"
  location                   = var.region
  labels                     = var.labels
  delete_contents_on_destroy = var.force_destroy

  depends_on = [time_sleep.wait_after_apis]
}

## Create a BigQuery connection for Cloud Storage to create BigLake tables
resource "google_bigquery_connection" "ds_connection" {
  project       = module.project-services.project_id
  connection_id = "ds_connection"
  location      = var.region
  friendly_name = "Storage Bucket Connection"
  cloud_resource {}
  depends_on = [time_sleep.wait_after_apis]
}

## Grant IAM access to the BigQuery Connection account for Cloud Storage
resource "google_project_iam_member" "bq_connection_iam_object_viewer" {
  project = module.project-services.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_bigquery_connection.ds_connection.cloud_resource[0].service_account_id}"

  depends_on = [google_project_iam_member.workflow_manage_sa_roles, google_bigquery_connection.ds_connection]
}

## Create a BigQuery connection for Vertex AI to support GenerativeAI use cases
resource "google_bigquery_connection" "vertex_ai_connection" {
  project       = module.project-services.project_id
  connection_id = "genai_connection"
  location      = var.region
  friendly_name = "BigQuery ML Connection"
  cloud_resource {}
  depends_on = [time_sleep.wait_after_apis]
}

## Define IAM roles granted to the BigQuery Connection service account
locals {
  bq_vertex_ai_roles = [
    "roles/aiplatform.user",
    "roles/bigquery.connectionUser",
    "roles/serviceusage.serviceUsageConsumer",
  ]
}

## Grant IAM access to the BigQuery Connection account for Vertex AI
resource "google_project_iam_member" "bq_connection_iam_vertex_ai" {
  count   = length(local.bq_vertex_ai_roles)
  role    = local.bq_vertex_ai_roles[count.index]
  project = module.project-services.project_id
  member  = "serviceAccount:${google_bigquery_connection.vertex_ai_connection.cloud_resource[0].service_account_id}"

  depends_on = [google_bigquery_connection.vertex_ai_connection, google_project_iam_member.bq_connection_iam_object_viewer]
}

# Create data tables in BigQuery
## Create a Biglake table for events with metadata caching
resource "google_bigquery_table" "tbl_edw_events" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "events"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/events_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/events.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for inventory_items
resource "google_bigquery_table" "tbl_edw_inventory_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "inventory_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/inventory_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/inventory_items.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table with metadata caching for order_items
resource "google_bigquery_table" "tbl_edw_order_items" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "order_items"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/order_items_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/order_items.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for orders
resource "google_bigquery_table" "tbl_edw_orders" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "orders"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/orders_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/orders.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_products" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "products"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/products_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/products.parquet"]
  }

  labels = var.labels
}

## Create a Biglake table for products
resource "google_bigquery_table" "tbl_edw_users" {
  dataset_id          = google_bigquery_dataset.ds_edw.dataset_id
  table_id            = "users"
  project             = module.project-services.project_id
  deletion_protection = var.deletion_protection

  schema = file("${path.module}/src/schema/users_schema.json")

  external_data_configuration {
    autodetect    = true
    connection_id = google_bigquery_connection.ds_connection.name
    source_format = "PARQUET"
    source_uris   = ["gs://${google_storage_bucket.raw_bucket.name}/thelook-ecommerce/users.parquet"]
  }

  labels = var.labels
}

# Load Queries for Stored Procedure Execution
## Load Distribution Center Lookup Data Tables
resource "google_bigquery_routine" "sp_provision_lookup_tables" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_provision_lookup_tables"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_provision_lookup_tables.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    }
  )
}

## Add Looker Studio Data Report Procedure
resource "google_bigquery_routine" "sproc_sp_demo_lookerstudio_report" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_lookerstudio_report"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_lookerstudio_report.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    }
  )

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
    google_bigquery_table.tbl_edw_order_items,
    google_bigquery_routine.sp_provision_lookup_tables,
  ]
}

## Add Sample Queries
resource "google_bigquery_routine" "sp_sample_queries" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_sample_queries"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_sample_queries.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    }
  )

  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items,
    google_bigquery_table.tbl_edw_order_items,
  ]
}


## Add Bigquery ML Model for clustering
resource "google_bigquery_routine" "sp_bigqueryml_model" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_bigqueryml_model"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_bigqueryml_model.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    }
  )
  depends_on = [
    google_bigquery_table.tbl_edw_order_items
  ]
}

## Create Bigquery ML Model for using text generation
resource "google_bigquery_routine" "sp_bigqueryml_generate_create" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_bigqueryml_generate_create"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_bigqueryml_generate_create.sql", {
    project_id    = module.project-services.project_id,
    dataset_id    = google_bigquery_dataset.ds_edw.dataset_id,
    connection_id = google_bigquery_connection.vertex_ai_connection.id,
    model_name    = var.text_generation_model_name,
    region        = var.region
    }
  )

  depends_on = [
    google_bigquery_routine.sp_bigqueryml_model,
    google_bigquery_connection.vertex_ai_connection
  ]
}

## Query Bigquery ML Model for describing customer clusters
resource "google_bigquery_routine" "sp_bigqueryml_generate_describe" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_bigqueryml_generate_describe"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_bigqueryml_generate_describe.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id,
    model_name = var.text_generation_model_name
    }
  )

  depends_on = [
    google_bigquery_routine.sp_bigqueryml_generate_create
  ]
}

## Add Translation Scripts
resource "google_bigquery_routine" "sp_sample_translation_queries" {
  project      = module.project-services.project_id
  dataset_id   = google_bigquery_dataset.ds_edw.dataset_id
  routine_id   = "sp_sample_translation_queries"
  routine_type = "PROCEDURE"
  language     = "SQL"
  definition_body = templatefile("${path.module}/src/sql/sp_sample_translation_queries.sql", {
    project_id = module.project-services.project_id,
    dataset_id = google_bigquery_dataset.ds_edw.dataset_id
    }
  )
  depends_on = [
    google_bigquery_table.tbl_edw_inventory_items
  ]
}

# Add Scheduled Query

# Create specific service account for DTS Run
## Create a DTS specific service account
resource "google_service_account" "dts" {
  project                      = module.project-services.project_id
  account_id                   = "cloud-dts-sa-${random_id.id.hex}"
  display_name                 = "Service Account for Data Transfer Service"
  description                  = "Service account used to manage Data Transfer Service"
  create_ignore_already_exists = var.create_ignore_service_accounts

  depends_on = [time_sleep.wait_after_apis]

}

## Define the IAM roles granted to the DTS service account
locals {
  dts_roles = [
    "roles/bigquery.user",
    "roles/bigquery.dataEditor",
    "roles/bigquery.connectionUser",
    "roles/iam.serviceAccountTokenCreator"
  ]
}

## Grant the DTS Specific service account access
resource "google_project_iam_member" "dts_roles" {
  project = module.project-services.project_id
  count   = length(local.dts_roles)
  role    = local.dts_roles[count.index]
  member  = "serviceAccount:${google_service_account.dts.email}"

  depends_on = [time_sleep.wait_after_apis, google_project_iam_member.bq_connection_iam_vertex_ai]
}

# Set up scheduled query
resource "google_bigquery_data_transfer_config" "dts_config" {

  display_name   = "nightlyloadquery"
  project        = module.project-services.project_id
  location       = var.region
  data_source_id = "scheduled_query"
  schedule       = "every day 00:00"
  params = {
    query = "CALL `${module.project-services.project_id}.${google_bigquery_dataset.ds_edw.dataset_id}.sp_bigqueryml_model`()"
  }
  service_account_name = google_service_account.dts.email

  depends_on = [
    google_project_iam_member.dts_roles,
    google_bigquery_dataset.ds_edw,
    module.workflow_polling_4
  ]
}
