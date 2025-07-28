variable "default_comment" {
  description = "Default comment."
  type        = string
}

variable "k3s_password" {
  description = "Password for the k3s cluster."
  type        = string
  sensitive   = true
}

variable "lan_bridge" {
  description = "The LAN bridge to use for the Proxmox VMs."
  type        = string
}

variable "mgmt_bridge" {
  description = "The management bridge to use for the Proxmox VMs."
  type        = string
}