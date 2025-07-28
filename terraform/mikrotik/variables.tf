variable "default_comment" {
  description = "Default comment."
  type        = string
}

variable "mikrotik_password" {
  description = "Mikrotik API Password"
  type        = string
  sensitive   = true
}