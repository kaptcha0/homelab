variable "default_comment" {
  description = "Default comment to append to firewall rules."
  type        = string
}

variable "interfaces" {
  description = "Network interfaces configuration."
  type        = map(string)
}