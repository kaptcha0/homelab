module "proxmox" {
  source = "./modules/proxmox/"
  
  pm_user    = var.pm_user   
  pm_api_url = var.pm_api_url
  pm_node    = var.pm_node   
  pm_bridge  = var.pm_bridge 

  vm_template_id = var.vm_template_id
  vm_storage     = var.vm_storage    
  vm_bridge      = var.vm_bridge     
  vm_user        = var.vm_user       
  vm_timeout     = var.vm_timeout    

  k3s_server_count     = var.k3s_server_count    
  k3s_server_cores     = var.k3s_server_cores    
  k3s_server_memory    = var.k3s_server_memory   
  k3s_server_disk_size = var.k3s_server_disk_size

  k3s_agent_count     = var.k3s_agent_count    
  k3s_agent_cores     = var.k3s_agent_cores    
  k3s_agent_memory    = var.k3s_agent_memory   
  k3s_agent_disk_size = var.k3s_agent_disk_size

  ssh_public_key = var.ssh_public_key

}
