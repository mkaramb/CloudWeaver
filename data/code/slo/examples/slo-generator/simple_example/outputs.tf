
# Note: As most of the submodules outputs are needed: we are just forwarding all
# submodules outputs here. Please refer to the submodules outputs.tf file to
# have a breakdown.

output "slo-generator" {
  value = module.slo-generator
}
