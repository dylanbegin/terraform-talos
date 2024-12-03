# Terraform provider for Kubernetes.

terraform {
  required_providers {
    proxmox   = {
      source  = "bpg/proxmox"
      version = ">= 0.65.0"
    }
    talos     = {
      source  = "siderolabs/talos"
      version = ">= 0.6.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.15.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.pve_host}:8006"
  api_token = var.pve_api_token
  insecure  = true
}
