{ config, lib, ... }:
{
  config = lib.mkIf config.vms.k3s.enable {
    resource."proxmox_virtual_environment_download_file".fedora-43 = {
      inherit (config.vms.config.proxmox) node_name;

      datastore_id = "local";
      content_type = "import";
      url = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2";
      file_name = "fedora-cloud-base-43-generic.qcow2";
    };
  };
}
