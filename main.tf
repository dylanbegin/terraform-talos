# Terraform provider for Kubernetes.

terraform {
  required_providers {
    proxmox   = {
      source  = "bpg/proxmox"
      version = ">= 0.111.1"
    }
    talos     = {
      source  = "siderolabs/talos"
      version = ">= 0.11.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 3.2.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.pve_host}:8006"
  api_token = var.pve_api_token
  insecure  = true
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
