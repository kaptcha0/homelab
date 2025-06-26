variable "pm_api_url" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "pm_user" {
  description = "Proxmox user"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID (e.g. root@pam!app-id)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API key"
  type        = string
  sensitive   = true
}

variable "pm_node" {
  description = "Proxmox node to deploy to"
  type        = string
}

variable "pm_bridge" {
  description = "Open Proxmox network bridge"
  type        = string
}

variable "vm_template_id" {
  description = "Cloud-init template Proxmox ID"
  type        = number
}

variable "vm_user" {
  description = "The user to use in the VM"
  type        = string
}


variable "vm_bridge" {
  description = "Isolated Proxmox network bridge"
  type        = string
}

variable "vm_storage" {
  description = "Proxmox storage pool name"
  type        = string
}

variable "vm_timeout" {
  description = "Timeout for VM operations (in seconds)"
  type        = number
}

variable "k3s_server_count" {
  description = "How many k3s servers to deploy"
  type        = number
}

variable "k3s_server_cores" {
  description = "Cores per server"
  type        = number
}

variable "k3s_server_memory" {
  description = "Memory per server (in MB)"
  type        = number
}

variable "k3s_server_disk_size" {
  description = "Disk size per server (in GB)"
  type        = number
}

variable "k3s_agent_count" {
  description = "How many k3s agents to deploy"
  type        = number
}

variable "k3s_agent_cores" {
  description = "Cores per agent"
  type        = number
}

variable "k3s_agent_memory" {
  description = "Memory per agent (in MB)"
  type        = number
}

variable "k3s_agent_disk_size" {
  description = "Disk size per agent (in GB)"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key path"
  type        = string
}
