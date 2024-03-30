
output "folder_ids" {
  value = [[for k, v in var.folder_map : module.folders[k].ids], [for i in local.sub_folders1_var : module.sub_folders1[i].ids], [for j in local.sub_folders2_var : module.sub_folders2[j].ids], [for l in local.sub_folders3_var : module.sub_folders3[l].ids]]
}
