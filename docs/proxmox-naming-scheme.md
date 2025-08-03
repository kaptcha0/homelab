# Proxmox Naming Scheme

Below is the naming convention for my Promox VMs

## Scheme

Plot twist: There is none! I've given up on using VMIDs for the reasons listed in [this Reddit thread](https://www.reddit.com/r/Proxmox/comments/xd5oxy/ids_and_naming_convention_what_is_the_best/)

TLDR? They're essentially useless. Since I'm working with Terraform, keeping track of IDs is a hassle. I'll just stick to using a mixture of tags and pools.

## Pools

- VMs
- Containers
- Networking

## Tags

- k3s
  - k3s-server
  - k3s-agent
- storage
- terraform
