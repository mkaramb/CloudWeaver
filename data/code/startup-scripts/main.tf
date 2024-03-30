
locals {
  stdlib_head       = file("${path.module}/files/startup-script-stdlib-head.sh")
  gsutil_el         = var.enable_init_gsutil_crcmod_el ? file("${path.module}/files/init_gsutil_crcmod_el.sh") : ""
  sudoers           = var.enable_setup_sudoers ? file("${path.module}/files/setup_sudoers.sh") : ""
  get_from_bucket   = var.enable_get_from_bucket ? file("${path.module}/files/get_from_bucket.sh") : ""
  setup_init_script = var.enable_setup_init_script && var.enable_get_from_bucket ? file("${path.module}/files/setup_init_script.sh") : ""
  stdlib_body       = file("${path.module}/files/startup-script-stdlib-body.sh")

  # List representing complete content, to be concatenated together.
  stdlib_list = [
    local.stdlib_head,
    local.gsutil_el,
    local.get_from_bucket,
    local.setup_init_script,
    local.sudoers,
    local.stdlib_body,
  ]

  # Final content output to the user
  stdlib = join("", local.stdlib_list)
}

