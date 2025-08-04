output "untagged_vlan" {
  value = {
    id       = 1
    comment  = "Default VLAN for untagged traffic"
    priority = 0
    gateway  = "172.64.0.1"
    domain   = "local.home"

    pools       = ["172.64.0.100-172.64.0.200"]
    dns_servers = ["172.64.0.1"]
    
    cidr = {
      network = "172.64.0.0"
      mask    = 24
    }

    static_leases = {
      "172.64.0.2" = {
        mac  = "20:c0:47:e8:44:78"
        name = "wifi_ap"
      }

      "172.64.0.3" = {
        mac  = "ea:bf:7a:11:7e:92"
        name = "netbootxyz"
      }

      "172.64.0.10" = {
        mac  = "70:66:55:FD:25:1B"
        name = "kaptcha"
      }

      "172.64.0.201" = {
        mac  = "CC:75:E2:50:5F:78"
        name = "stb"
      }

      "172.64.0.202" = {
        mac  = "50:57:9c:47:40:56"
        name = "printer"
      }
    }
  }
}

output "services_vlan" {
  value = {
    id       = 10
    comment  = "Services VLAN"
    priority = 0
    gateway  = "172.64.10.1"
    domain   = "srv.home"

    pools       = ["172.64.10.100-172.64.10.200"]
    dns_servers = ["172.64.10.1"]
    
    cidr = {
      network = "172.64.10.0"
      mask    = 24
    }

    static_leases = {}
  }
}

output "storage_vlan" {
  value = {
    id       = 20
    comment  = "Storage VLAN"
    priority = 0
    gateway  = "172.64.20.1"
    domain   = "strg.home"

    pools       = ["172.64.20.100-172.64.20.200"]
    dns_servers = ["172.64.20.1"]
    
    cidr = {
      network = "172.64.20.0"
      mask    = 24
    }

    static_leases = {}

  }
}

output "dmz_vlan" {
  value = {
    id       = 30
    comment  = "DMZ VLAN"
    priority = 0
    gateway  = "172.64.30.1"
    domain   = "dmz.home"

    pools       = ["172.64.30.100-172.64.30.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
    
    cidr = {
      network = "172.64.30.0"
      mask    = 24
    }

    static_leases = {}
  }
}

output "remote_vlan" {
  value = {
    id       = 40
    comment  = "Remote access VLAN"
    priority = 0
    gateway  = "172.64.40.1"
    domain   = "remote.home"

    pools       = ["172.64.40.100-172.64.40.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
   
    cidr = {
      network = "172.64.40.0"
      mask    = 24
    }

    static_leases = {}
  }
}

output "isolated_vlan" {
  value = {
    id       = 50
    comment  = "Isolated VLAN"
    priority = 0
    gateway  = "172.64.50.1"
    domain   = "iso.home"

    pools       = ["172.64.50.100-172.64.50.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
   
    cidr = {
      network = "172.64.50.0"
      mask    = 24
    }

    static_leases = {}
  }
}

output "management_vlan" {
  value = {
    id       = 99
    comment  = "Management VLAN"
    priority = 0
    gateway  = "172.64.99.1"
    domain   = "mgmt.home"

    pools       = ["172.64.99.100-172.64.99.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]

    cidr = {
      network = "172.64.99.0"
      mask    = 24
    }

    static_leases = {}
  }
}
