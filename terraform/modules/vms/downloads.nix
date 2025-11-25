{ config, lib, ... }:
{
  config = lib.mkIf config.vms.k3s.enable {
    resource."proxmox_virtual_environment_download_file".latest_ubuntu_22_jammy_qcow2_img = {
      inherit (config.vms.k3s.config.proxmox) node_name;

      datastore_id = "local";
      content_type = "import";
      url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img";
      # need to rename the file to *.qcow2 to indicate the actual file format for import
      file_name = "jammy-server-cloudimg-amd64.qcow2";
    };
  };
}
