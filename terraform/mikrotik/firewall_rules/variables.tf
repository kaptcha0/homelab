variable "mikrotik_host_url" {
  description = "The URL of the MikroTik router."
  type        = string
  
}

variable "mikrotik_user" {
  description = "The username for the MikroTik router."
  type        = string
}

variable "mikrotik_password" {
  description = "The password for the MikroTik router."
  type        = string
}

variable "default_comment" {
  description = "Default comment to append to firewall rules."
  type        = string
}

variable "interfaces" {
  description = "Network interfaces configuration."
  type        = map(string)
}