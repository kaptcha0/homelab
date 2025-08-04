# Inital RouterOS Config
Below are the initial configurations I made in RouterOS to get everything to work.

See [here](../infrastructure/files/basic-install.rsc) the config file that includes everything except the certificates.

## API Access
```rsc
/certificate
add name=local-root-cert common-name=local-cert key-size=prime256v1 key-usage=key-cert-sign,crl-sign trusted=yes
sign local-root-cert

add name=webfig common-name=10.67.0.1 country=US organization=KAPTCHA unit=HOME days-valid=3650 key-size=prime256v1 key-usage=key-cert-sign,crl-sign,digital-signature,key-agreement,tls-server trusted=yes
sign ca=local-root-cert webfig

/ip service
set www-ssl certificate=webfig disabled=no
enable www-ssl
```

## Interface and bridge set up

```rsc
/interface bridge
add name=lan-bridge vlan-filtering=yes

/interface bridge port
add bridge=lan-bridge interface=ether3 pvid=99

/interface bridge vlan
add bridge=lan-bridge vlan-ids=99 tagged=lan-bridge untagged=ether3

/interface vlan
add interface=lan-bridge name=vlan99 vlan-id=99

/ip address
add address=10.67.99.1/24 interface=vlan99
```

## DHCP

```rsc
/ip pool
add name=pool99  ranges=10.67.99.100-10.67.99.200

/ip dhcp-server
add name=dhcp99  interface=vlan99  address-pool=pool99  lease-time=30m

/ip dhcp-server network
add address=10.67.99.0/24  gateway=10.67.99.1

```
