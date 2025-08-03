variable "k3s_disk_import_id" {
  description = "The ID of the disk to import for k3s VMs"
  type        = string
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

variable "omv_iso_import_id" {
  description = "The ID of the disk to import for OMV"
  type        = string
}