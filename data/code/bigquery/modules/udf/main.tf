
module "bq_find_in_set" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.find_in_set(str STRING, strList STRING)
  AS (
    CASE
      WHEN STRPOS(str, ',') > 0 THEN 0
      ELSE
      (
        WITH list AS (
          SELECT ROW_NUMBER() OVER() id, l FROM UNNEST(SPLIT(strList, ',')) l
        )
        (SELECT id FROM list WHERE l = str)
      )
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.find_in_set\""
}

module "bq_check_protocol" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.check_protocol(url STRING)
  AS (
    CASE
      WHEN REGEXP_CONTAINS(url, '^[a-zA-Z]+://') THEN url
      ELSE CONCAT('http://', url)
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.check_protocol\""
}

module "bq_parse_url" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"
  enabled = module.bq_check_protocol.wait != "" && var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.parse_url(url STRING, part STRING)
  AS (
    CASE
      -- Return HOST part of the URL.
      WHEN part = 'HOST' THEN SPLIT(\`${var.project_id}\`.${var.dataset_id}.check_protocol(url), '/')[OFFSET(2)]
      WHEN part = 'REF' THEN
        IF(REGEXP_CONTAINS(url, '#'), SPLIT(\`${var.project_id}\`.${var.dataset_id}.check_protocol
        (url), '#')[OFFSET(1)], NULL)
      WHEN part = 'PROTOCOL' THEN RTRIM(REGEXP_EXTRACT(url, '^[a-zA-Z]+://'), '://')
      ELSE ''
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.parse_url\""
}

module "bq_csv_to_struct" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"
  enabled = var.add_udfs

  platform              = "linux"
  additional_components = ["bq"]

  create_cmd_entrypoint  = "bq"
  destroy_cmd_entrypoint = "bq"

  create_cmd_body = <<EOT
--project_id ${var.project_id} query --use_legacy_sql=false "CREATE FUNCTION IF NOT EXISTS ${var.dataset_id}.csv_to_struct(strList STRING)
  AS (
    CASE
      WHEN REGEXP_CONTAINS(strList, ',') OR REGEXP_CONTAINS(strList, ':') THEN
        (ARRAY(
          WITH list AS (
            SELECT l FROM UNNEST(SPLIT(TRIM(strList), ',')) l WHERE REGEXP_CONTAINS(l, ':')
          )
          SELECT AS STRUCT
              TRIM(SPLIT(l, ':')[OFFSET(0)]) AS key, TRIM(SPLIT(l, ':')[OFFSET(1)]) as value
          FROM list
        ))
      ELSE NULL
    END
  );"
EOT

  destroy_cmd_body = "--project_id ${var.project_id} query --use_legacy_sql=false \"DROP FUNCTION IF EXISTS ${var.dataset_id}.csv_to_struct\""
}
