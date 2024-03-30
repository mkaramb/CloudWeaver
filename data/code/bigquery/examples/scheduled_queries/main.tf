
module "dataset" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 7.0"

  dataset_id   = "example_dataset"
  dataset_name = "example_dataset"
  description  = "Example description"
  project_id   = "example-project"
  location     = "EU"
}

module "scheduled_queries" {
  source  = "terraform-google-modules/bigquery/google//modules/scheduled_queries"
  version = "~> 7.0"

  project_id = module.dataset.project

  queries = [
    {
      name                   = "my-query"
      location               = "EU"
      data_source_id         = "scheduled_query"
      destination_dataset_id = module.dataset.bigquery_dataset.dataset_id
      params = {
        destination_table_name_template = "my_table"
        write_disposition               = "WRITE_APPEND"
        query                           = "SELECT name FROM tabl WHERE x = 'y'"
      }
    }
  ]
}
