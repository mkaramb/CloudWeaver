

resource "google_storage_bucket" "artifacts" {
  name          = var.bucket_name
  project       = var.project_id
  force_destroy = true
}

data "local_file" "artifact_upload_job_template" {
  filename = "${path.module}/templates/artifact_upload_job.xml.tpl"
}

data "template_file" "artifact_upload_job" {
  count = var.jobs_count

  template = data.local_file.artifact_upload_job_template.content

  vars = {
    project_id            = var.project_id
    build_artifact_bucket = google_storage_bucket.artifacts.url

    job_name     = var.jobs[count.index].name
    job_builders = join("\n", var.jobs[count.index].builders)
  }
}

data "null_data_source" "jobs" {
  count = var.jobs_count

  inputs = {
    name     = var.jobs[count.index].name
    manifest = data.template_file.artifact_upload_job[count.index].rendered
  }
}
