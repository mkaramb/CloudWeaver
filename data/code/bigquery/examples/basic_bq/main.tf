
module "bigquery" {
  source  = "terraform-google-modules/bigquery/google"
  version = "~> 7.0"

  dataset_id                 = "foo"
  dataset_name               = "foo"
  description                = "some description"
  project_id                 = var.project_id
  location                   = "US"
  delete_contents_on_destroy = var.delete_contents_on_destroy
  tables = [
    {
      table_id           = "bar",
      schema             = file("sample_bq_schema.json"),
      time_partitioning  = null,
      range_partitioning = null,
      expiration_time    = 2524604400000, # 2050/01/01
      clustering         = [],
      labels = {
        env      = "devops"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
  dataset_labels = {
    env      = "dev"
    billable = "true"
    owner    = "janesmith"
  }
}
