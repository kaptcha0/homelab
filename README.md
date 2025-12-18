# homelab

This repo contains my declarative homelab configuration.

## technologies used

- Kubernetes/k3s for containerizing applications
- Terraform for provisioning VMs using Proxmox
  - Terranix for building the terraform configuration file using Nix code

## why nix/nixos?

Originally, I was planning to use regular Terraform and Ansible to provision and set up my VMs.
 However, after many headaches with Ansible, and my rediscovery of the Nix way of thinking, I decided to try to Nix-ify as much as possible.
 The goal now is to have a single, reproducable, reliable command to provision, configure, and deploy all my services.
