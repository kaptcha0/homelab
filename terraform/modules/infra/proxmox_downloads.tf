resource "proxmox_virtual_environment_download_file" "downloads" {
  for_each = module.shared.proxmox_config.downloads

  node_name = module.shared.proxmox_config.primary_node
  content_type = each.value.content_type
  file_name    = each.value.file_name
  datastore_id = each.value.datastore_id
  url          = each.value.url
}

output "proxmox_downloads" {
  value = {
    for key, download in proxmox_virtual_environment_download_file.downloads :
    key => {
      id          = download.id
    }
  }
}