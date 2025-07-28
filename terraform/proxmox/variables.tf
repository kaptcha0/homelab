variable "default_comment" {
  description = "Default comment."
  type        = string
}

variable "pm_api_token" {
  description = "Proxmox API token in the format 'id=secret'"
  type        = string
  sensitive   = true
}