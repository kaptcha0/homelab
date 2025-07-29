locals {
  routeros_config = {
    interfaces = {
      wan        = "ether1"
      lan        = "ether2"
      mgmt       = "ether3"
      lan_bridge = "lan-bridge"
    }
  }
}