
output "revision_name" {
  value       = local.revision_name
  description = "The name of the installed managed ASM revision."
}

output "wait" {
  value       = var.mesh_management == "MANAGEMENT_AUTOMATIC" ? module.kubectl_asm_wait_for_controlplanerevision[0].wait : module.cpr[0].wait
  description = "An output to use when depending on the ASM installation finishing."
}
