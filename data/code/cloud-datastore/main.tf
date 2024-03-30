
locals {
  path_file            = "${path.module}/tmp/index.yaml"
  null_index_path_file = "${path.module}/null_index/index.yaml"
}

resource "local_file" "cloud-datastore-index-file" {
  content  = var.indexes
  filename = local.path_file
}

resource "null_resource" "cloud-datastore-indices" {
  triggers = {
    changes_in_index_file      = sha1(local_file.cloud-datastore-index-file.content)
    local_null_index_path_file = local.null_index_path_file
    path_module                = path.module
    var_project                = var.project
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-indexes.sh '${var.project}' '${local_file.cloud-datastore-index-file.filename}'"
  }

  provisioner "local-exec" {
    command = "${self.triggers.path_module}/scripts/destroy-indexes.sh '${self.triggers.var_project}' '${self.triggers.local_null_index_path_file}'"
    when    = destroy
  }
}
