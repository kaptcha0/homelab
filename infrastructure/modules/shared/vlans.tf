output "untagged_vlan" {
  value = {
    id       = 1
    comment  = "Default VLAN for untagged traffic"
    priority = 0
    gateway  = "10.67.0.1"
    domain   = "local.home"

    pools       = ["10.67.0.100-10.67.0.200"]
    dns_servers = ["10.67.0.1"]
    
    cidr = {
      network = "10.67.0.0"
      mask    = 24
    }

    static_leases = {
      "10.67.0.2" = {
        mac  = "20:c0:47:e8:44:78"
        name = "wifi_ap"
      }

      "10.67.0.10" = {
        mac  = "70:66:55:FD:25:1B"
        name = "kaptcha"
      }

      "10.67.0.201" = {
        mac  = "CC:75:E2:50:5F:78"
        name = "stb"
      }

      "10.67.0.202" = {
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
    gateway  = "10.67.10.1"
    domain   = "srv.home"

    pools       = ["10.67.10.100-10.67.10.200"]
    dns_servers = ["10.67.10.1"]
    
    cidr = {
      network = "10.67.10.0"
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
    gateway  = "10.67.20.1"
    domain   = "strg.home"

    pools       = ["10.67.20.100-10.67.20.200"]
    dns_servers = ["10.67.20.1"]
    
    cidr = {
      network = "10.67.20.0"
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
    gateway  = "10.67.30.1"
    domain   = "dmz.home"

    pools       = ["10.67.30.100-10.67.30.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
    
    cidr = {
      network = "10.67.30.0"
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
    gateway  = "10.67.40.1"
    domain   = "remote.home"

    pools       = ["10.67.40.100-10.67.40.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
   
    cidr = {
      network = "10.67.40.0"
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
    gateway  = "10.67.50.1"
    domain   = "iso.home"

    pools       = ["10.67.50.100-10.67.50.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]
   
    cidr = {
      network = "10.67.50.0"
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
    gateway  = "10.67.99.1"
    domain   = "mgmt.home"

    pools       = ["10.67.99.100-10.67.99.200"]
    dns_servers = ["1.1.1.1", "8.8.8.8"]

    cidr = {
      network = "10.67.99.0"
      mask    = 24
    }

    static_leases = {}
  }
}

output "routeros_config" {
  value = local.routeros_config
}