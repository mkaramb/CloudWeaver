
locals {
  filename = abspath("${path.module}/file-${random_pet.filename.id}.txt")
}

resource "random_pet" "filename" {
  keepers = {
    always = uuid()
  }
}

module "hello" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} hello"
}

module "two" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} two"
}

module "goodbye" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} goodbye"

  module_depends_on = [
    module.hello.wait,
    module.two.wait
  ]
}
