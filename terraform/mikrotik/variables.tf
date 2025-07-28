variable "default_comment" {
  description = "Default comment to append to firewall rules."
  type        = string
}

variable "mikrotik_password" {
  description = "Mikrotik API Password"
  type        = string
  sensitive   = true
}