variable "default_comment" {
  description = "Default comment."
  type        = string
}

variable "k3s_password" {
  description = "Password for the k3s cluster."
  type        = string
  sensitive   = true
}